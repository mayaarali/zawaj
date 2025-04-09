part of 'payment_bloc.dart';

abstract class PaymentEvent {}

class Payment extends PaymentEvent {}

class VerifyPayment extends PaymentEvent {
  final int? plainId;
  final int? standardValue;
  String userId;
  String url;
  VerifyPayment(
      {this.standardValue,
      this.plainId,
      required this.url,
      required this.userId});
}

class ChoosePlan extends PaymentEvent {
  final int? id;
  final int? standardValue;

  ChoosePlan({
    this.id,
    this.standardValue,
  });
}
