import 'dart:convert';

List<LikedPartnersModel> likedPartnersModelFromJson(String str) =>
    List<LikedPartnersModel>.from(
        json.decode(str).map((x) => LikedPartnersModel.fromJson(x)));

class LikedPartnersModel {
  int? id;
  String? userId;
  String? name;
  String? about;
  String? city;
  String? area;
  String? gender;
  int? age;
  String? maritalStatus;
  double? height;
  double? weight;
  bool? isSmoking;
  bool? isLiked;
  List<String>? images;
  List<Parameter>? parameters;

  LikedPartnersModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.about,
    required this.city,
    required this.area,
    required this.gender,
    required this.age,
    required this.maritalStatus,
    required this.height,
    required this.weight,
    required this.isSmoking,
    required this.images,
    required this.parameters,
    required this.isLiked,
  });

  factory LikedPartnersModel.fromJson(Map<String, dynamic> json) =>
      LikedPartnersModel(
        id: json["setupId"],
        userId: json["userId"],
        name: json["name"],
        about: json["about"],
        city: json["city"],
        area: json["area"],
        gender: json["gender"],
        age: json["age"],
        maritalStatus: json["maritalStatus"],
        height: json["height"]?.toDouble(),
        weight: json["weight"]?.toDouble(),
        isSmoking: json["isSmoking"],
        isLiked: json["isLiked"],
        images: List<String>.from(json["images"].map((x) => x)),
        parameters: List<Parameter>.from(
            json["parameters"].map((x) => Parameter.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "setupId": id,
        "userId": userId,
        "name": name,
        "about": about,
        "city": city,
        "area": area,
        "gender": gender,
        "age": age,
        "maritalStatus": maritalStatus,
        "height": height,
        "weight": weight,
        "isSmoking": isSmoking,
        "isLiked": isLiked,
        "images": List<dynamic>.from(images!.map((x) => x)),
        "parameters": List<dynamic>.from(parameters!.map((x) => x.toJson())),
      };
}

class Parameter {
  String? parameterName;
  int? parameterType;
  int? valueId;
  String? valueName;

  Parameter({
    required this.parameterName,
    required this.parameterType,
    required this.valueId,
    required this.valueName,
  });

  factory Parameter.fromJson(Map<String, dynamic> json) => Parameter(
        parameterName: json["parameterName"],
        parameterType: json["parameterType"],
        valueId: json["valueId"],
        valueName: json["valueName"],
      );

  Map<String, dynamic> toJson() => {
        "parameterName": parameterName,
        "parameterType": parameterType,
        "valueId": valueId,
        "valueName": valueName,
      };
}
