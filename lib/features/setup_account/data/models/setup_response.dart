// To parse this JSON data, do
//
//     final setupResponse = setupResponseFromJson(jsonString);

import 'dart:convert';

SetupResponse setupResponseFromJson(String str) =>
    SetupResponse.fromJson(json.decode(str));

String setupResponseToJson(SetupResponse data) => json.encode(data.toJson());

class SetupResponse {
  String? message;
  Parameter? parameter;

  SetupResponse({
    this.message,
    this.parameter,
  });

  factory SetupResponse.fromJson(Map<String, dynamic> json) => SetupResponse(
        message: json["message"],
        parameter: json["parameter"] == null
            ? null
            : Parameter.fromJson(json["parameter"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "parameter": parameter?.toJson(),
      };
}

class Parameter {
  int? id;
  int? religion;
  int? gender;
  int? searchGender;
  String? name;
  int? birthYear;
  int? maritalStatus;
  List<String>? imagesPath;
  double? height;
  double? weight;
  bool? isSmoking;
  int? cityId;
  String? city;
  int? areaId;
  String? area;
  List<dynamic>? parameters;

  Parameter({
    this.id,
    this.religion,
    this.gender,
    this.searchGender,
    this.name,
    this.birthYear,
    this.maritalStatus,
    this.imagesPath,
    this.height,
    this.weight,
    this.isSmoking,
    this.cityId,
    this.city,
    this.areaId,
    this.area,
    this.parameters,
  });

  factory Parameter.fromJson(Map<String, dynamic> json) => Parameter(
        id: json["id"],
        religion: json["Religion"],
        gender: json["gender"],
        searchGender: json["searchGender"],
        name: json["name"],
        birthYear: json["birthYear"],
        maritalStatus: json["maritalStatus"],
        imagesPath: json["imagesPath"] == null
            ? []
            : List<String>.from(json["imagesPath"]!.map((x) => x)),
        height: json["height"].toDouble(),
        weight: json["weight"].toDouble(),
        isSmoking: json["isSmoking"],
        cityId: json["cityId"],
        city: json["city"],
        areaId: json["areaId"],
        area: json["area"],
        parameters: json["parameters"] == null
            ? []
            : List<dynamic>.from(json["parameters"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "religion": religion,
        "gender": gender,
        "searchGender": searchGender,
        "name": name,
        "birthYear": birthYear,
        "maritalStatus": maritalStatus,
        "imagesPath": imagesPath == null
            ? []
            : List<dynamic>.from(imagesPath!.map((x) => x)),
        "height": height,
        "weight": weight,
        "isSmoking": isSmoking,
        "cityId": cityId,
        "city": city,
        "areaId": areaId,
        "area": area,
        "parameters": parameters == null
            ? []
            : List<dynamic>.from(parameters!.map((x) => x)),
      };
}
