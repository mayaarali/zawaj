import 'dart:convert';

List<PaymentModel> paymentModelFromJson(String str) => List<PaymentModel>.from(
    json.decode(str).map((x) => PaymentModel.fromJson(x)));
String paymentModelToJson(List<PaymentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentModel {
  int? id;
  int? months;
  int? amount;

  PaymentModel({
    this.id,
    this.months,
    this.amount,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        id: json["id"],
        months: json["months"],
        amount: json["amount"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "months": months,
        "amount": amount,
      };
}

class StandardPaymentValueModel {
  String standardValue;

  StandardPaymentValueModel({required this.standardValue});

  factory StandardPaymentValueModel.fromJson(Map<String, dynamic> json) {
    return StandardPaymentValueModel(
      standardValue: json['standardValue'] is String
          ? json['standardValue']
          : json['standardValue'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'standardValue': standardValue,
    };
  }
}
