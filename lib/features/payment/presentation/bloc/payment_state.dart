part of 'payment_bloc.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentChange extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  List<PaymentModel> paymentModel;
  PaymentSuccess(this.paymentModel);
}

final class PaymentFailure extends PaymentState {
  String message;
  PaymentFailure({required this.message});
}

class ChoosePlanSuccess extends PaymentState {
  String message;

  ChoosePlanSuccess({required this.message});
}

final class ChoosePlanFailure extends PaymentState {
  String message;
  ChoosePlanFailure({required this.message});
}

class VerifyPaymentSuccess extends PaymentState {
  String message;

  VerifyPaymentSuccess({required this.message});
}

final class VerifyPaymentFailure extends PaymentState {
  String message;
  VerifyPaymentFailure({required this.message});
}

// New States for Standard Payment Plan
class PaymentStandardLoading extends PaymentState {}

class PaymentStandardSuccess extends PaymentState {
  List<StandardPaymentValueModel> standardPaymentModel;
  PaymentStandardSuccess(this.standardPaymentModel);
}

final class PaymentStandardFailure extends PaymentState {
  String message;
  PaymentStandardFailure({required this.message});
}
