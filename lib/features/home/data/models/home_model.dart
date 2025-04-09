import 'dart:convert';

List<HomeModel> cityModelFromJson(String str) =>
    List<HomeModel>.from(json.decode(str).map((x) => HomeModel.fromJson(x)));

class HomeModel {
  int? id;
  String? userId;
  String? name;
  String? about;
  String? city;
  String? area;
  String? gender;
  String? religion;
  int? age;
  String? maritalStatus;
  double? height;
  double? weight;
  bool? isSmoking;
  bool? isLiked;
  List<String>? images;
  List<Parameter>? parameters;

  HomeModel(
      {required this.id,
      required this.name,
      required this.userId,
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
      this.religion});

  static HomeModel empty() {
    return HomeModel(
        id: 0,
        name: '',
        userId: '',
        about: '',
        city: '',
        gender: '',
        area: '',
        age: null,
        maritalStatus: '',
        weight: null,
        isSmoking: null,
        isLiked: null,
        images: [],
        parameters: [],
        height: null);
  }

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
        id: json["setupId"],
        name: json["name"],
        userId: json["userId"],
        about: json["about"],
        city: json["city"],
        area: json["area"],
        gender: json["gender"],
        religion: json["religion"],
        age: json["age"],
        maritalStatus: json["maritalStatus"],
        height: json["height"]?.toDouble(),
        weight: json["weight"]?.toDouble(),
        isSmoking: json["isSmoking"],
        isLiked: json["isLiked"],
        images: List<String>.from(json["images"].map((x) => x)),
        parameters: json["parameters"] == null
            ? null
            : List<Parameter>.from(
                json["parameters"].map((x) => Parameter.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "setupId": id,
        "name": name,
        "userId": userId,
        "about": about,
        "religion": religion,
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
