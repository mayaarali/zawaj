import 'dart:convert';

List<ConsultantModel> consultantModelFromJson(String str) =>
    List<ConsultantModel>.from(
        json.decode(str).map((x) => ConsultantModel.fromJson(x)));

String consultantModelToJson(List<ConsultantModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ConsultantModel {
  int? id;
  int? clickCount;
  String? name;
  String? address;
  String? phone;
  String? service;

  ConsultantModel({
    required this.id,
    required this.clickCount,
    required this.name,
    required this.address,
    required this.phone,
    required this.service,
  });

  factory ConsultantModel.fromJson(Map<String, dynamic> json) =>
      ConsultantModel(
        id: json["id"],
        clickCount: json["clickCount"],
        name: json["name"],
        address: json["address"],
        phone: json["phone"],
        service: json["service"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "clickCount": clickCount,
        "name": name,
        "address": address,
        "phone": phone,
        "service": service,
      };
}
