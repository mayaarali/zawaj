import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/consultants/data/models/consultants_model.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/consultants/data/repo/consultant_repository.dart';

part 'consultant_event.dart';
part 'consultant_state.dart';

class ConsultantBloc extends Bloc<ConsultantEvent, ConsultantState> {
  static ConsultantBloc get(context) => BlocProvider.of(context);
  ScrollController scrollController = ScrollController();
  ConsultantRepositoryImp consultantRepositoryImp;
  ConsultantModel? consultantModel;
  List<ConsultantModel> consultantModelList = [];
  String? phoneNumber;
  int currentPage = 1;
  bool isLoadingMore = false;

  TextEditingController searchController = TextEditingController();

  ConsultantBloc({required this.consultantRepositoryImp})
      : super(ConsultantInitial()) {
    on<ClickConsultantEvent>((event, emit) async {
      emit(ClickConsultantLoading());

      var response = await consultantRepositoryImp.clickConsultant(
        consultantId: event.consultantId,
      );
      response.fold((failure) {
        emit(ClickConsultantFailed(message: failure));
      }, (message) {
        emit(ClickConsultantSuccess(message: message));
      });
    });
  }

  // }

  getConsultantData({bool loadMore = false}) async {
    if (!loadMore) {
      emit(ConsultantLoading());
    } else {
      isLoadingMore = true;
      emit(ConsultantSuccess(consultantModelList));
    }

    try {
      var response = await consultantRepositoryImp.getConsultant(
        search: searchController.text,
        page: currentPage,
      );

      response.fold((failure) {
        emit(ConsultantFailed(message: failure));
      }, (model) {
        if (loadMore) {
          consultantModelList.addAll(model);
        } else {
          consultantModelList = model;
          currentPage = 1;
        }

        emit(ConsultantSuccess(consultantModelList));
        if (model.isNotEmpty) {
          currentPage++;
        }
      });
    } catch (e) {
      log('eeeee =>$e');
      emit(ConsultantFailed(message: 'Failed to fetch consultants: $e'));
    } finally {
      if (loadMore) {
        isLoadingMore = false;
      }
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
      emit(CallConsultant());
    } else {
      print('............................Phone Call Failed');
    }
  }
}
