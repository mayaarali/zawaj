import 'dart:convert';

List<AreaModel> areaModelFromJson(String str) =>
    List<AreaModel>.from(json.decode(str).map((x) => AreaModel.fromJson(x)));
String areaModelToJson(List<AreaModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AreaModel {
  int? id;
  String? area;

  AreaModel({
    this.id,
    this.area,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) => AreaModel(
        id: json["id"],
        area: json["name"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": area,
      };
}
