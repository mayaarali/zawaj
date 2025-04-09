import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/features/payment/data/models/payment_model.dart';
import 'package:zawaj/features/payment/data/repos/payment_repository.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepositoryImp paymentRepositoryImp;
  final TextEditingController cardController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  var amount;
  var month;
  var selectedIndex;
  var planId;
  var standardValuePayment;

  List<PaymentModel> payList = [];
  List<StandardPaymentValueModel> standardPayList = [];

  int selectedStandardPayIndex = -1;
  int selectedPayIndex = -1;

  static PaymentBloc get(BuildContext context) =>
      BlocProvider.of<PaymentBloc>(context);

  PaymentBloc({required this.paymentRepositoryImp}) : super(PaymentInitial()) {
    on<ChoosePlan>((event, emit) async {
      emit(PaymentLoading());
      log('Fetching response for ChoosePlan');

      final response = await paymentRepositoryImp.addPaymentPlan(
        plainId: event.id,
        standardValue: event.standardValue,
      );

      response.fold(
        (failure) => emit(ChoosePlanFailure(message: failure)),
        (message) => emit(ChoosePlanSuccess(message: message)),
      );
    });

    on<VerifyPayment>((event, emit) async {
      emit(PaymentLoading());

      final response = await paymentRepositoryImp.verifyPayment(
        plainId: planId,
        standardValue: standardValuePayment,
        userId: event.userId,
        url: event.url,
      );

      response.fold(
        (failure) => emit(VerifyPaymentFailure(message: failure)),
        (message) => emit(VerifyPaymentSuccess(message: message)),
      );
    });
  }

  Future<void> getPaymentPlan() async {
    emit(PaymentLoading());
    log('Fetching payment plan');

    final response = await paymentRepositoryImp.getPaymentPlan();

    payList.clear();
    response.fold(
      (failure) => emit(PaymentFailure(message: failure)),
      (paymentModels) {
        payList = paymentModels;
        emit(PaymentSuccess(paymentModels));
        log("Payment success");
      },
    );
  }

  Future<void> getPaymentStandardPlan() async {
    emit(PaymentStandardLoading());
    log('Fetching standard payment values');

    final response = await paymentRepositoryImp.getPaymentStandardPlan();

    standardPayList.clear();
    response.fold(
      (failure) => emit(PaymentStandardFailure(message: failure)),
      (standardPaymentModels) {
        standardPayList = standardPaymentModels;
        emit(PaymentStandardSuccess(standardPaymentModels));
        log("Standard payment fetch success");
      },
    );
  }

  void selectStandardPayIndex(int index) {
    selectedStandardPayIndex = index;
    selectedPayIndex = -1;
    emit(PaymentChange());
  }

  void selectPayIndex(int index) {
    selectedPayIndex = index;
    selectedStandardPayIndex = -1;
    emit(PaymentChange());
  }

  changePaymentData({amounts, months, index, id, standardValue}) {
    amount = amounts;
    month = months;
    planId = id;
    standardValuePayment = standardValue;
    selectedIndex = index;
    emit(PaymentChange());
  }

  @override
  Future<void> close() {
    cardController.dispose();
    cvvController.dispose();
    endDateController.dispose();
    return super.close();
  }
}
