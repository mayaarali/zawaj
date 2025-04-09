// To parse this JSON data, do
//
//     final paramsModel = paramsModelFromJson(jsonString);

import 'dart:convert';

List<ParamsModel> paramsModelFromJson(String str) => List<ParamsModel>.from(
    json.decode(str).map((x) => ParamsModel.fromJson(x)));

String paramsModelToJson(List<ParamsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ParamsModel {
  int? id;
  String? title;
  int? type;
  List<Value>? values;

  ParamsModel({this.id, this.title, this.values, this.type});

  factory ParamsModel.fromJson(Map<String, dynamic> json) => ParamsModel(
        id: json["parameterId"],
        type: json["parameterType"],
        title: json["title"],
        values: json["values"] == null
            ? []
            : List<Value>.from(json["values"]!.map((x) => Value.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "parameterId": id,
        "title": title,
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class Value {
  int? id;
  String? value;

  Value({
    this.id,
    this.value,
  });

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        id: json["id"]==0?null:json["id"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id==0?null:id,
        "value": value,
      };
}

class ValueBody {
  int? valueId, paramId;
  String? value;

  ValueBody({this.paramId, this.value, this.valueId});

  Map<String, dynamic> toJson() => {
        "valueId": valueId==0?null:valueId,
        "parameterId": paramId,
        "value": value,
      };
}

class Checked {
  int? index;
  bool? value;

  Checked({
    this.index,
    this.value,
  });
}
