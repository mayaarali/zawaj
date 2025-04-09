import 'dart:convert';

List<CityModel> cityModelFromJson(String str) =>
    List<CityModel>.from(json.decode(str).map((x) => CityModel.fromJson(x)));
String cityModelToJson(List<CityModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CityModel {
  int? id;
  String? city;

  CityModel({
    this.id,
    this.city,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        id: json["id"],
        city: json["name"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": city,
      };
}
