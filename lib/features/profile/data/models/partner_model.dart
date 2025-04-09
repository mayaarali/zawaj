class PartnerData {
  int? minAge;
  int? maxAge;
  int? minWeight;
  int? maxWeight;
  int? minHeight;
  int? maxHeight;
  String? gender;
  String? religion;
  bool? isSmoking;
  List<Parameter>? parameters;

  PartnerData(
      {this.minAge,
      this.maxAge,
      this.gender,
      this.isSmoking,
      this.parameters,
      this.maxHeight,
      this.minHeight,
      this.maxWeight,
      this.religion,
      this.minWeight});

  factory PartnerData.fromJson(Map<String, dynamic> json) => PartnerData(
        minAge: json["minAge"],
        maxAge: json["maxAge"],
        religion: json["religion"],
        gender: json["gender"],
        minHeight: json["minHeight"]?.toInt(),
        minWeight: json["minWeight"]?.toInt(),
        maxWeight: json["maxWeight"]?.toInt(),
        maxHeight: json["maxHeight"]?.toInt(),
        isSmoking: json["isSmoking"],
        parameters: json["parameters"] == null
            ? []
            : List<Parameter>.from(
                json["parameters"]!.map((x) => Parameter.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "minAge": minAge,
        "maxAge": maxAge,
        "gender": gender,
        "isSmoking": isSmoking,
        "parameters": parameters == null
            ? []
            : List<dynamic>.from(parameters!.map((x) => x.toJson())),
      };
}

class Parameter {
  String? parameterName;
  int? parameterType;
  int? valueId, parameterId;
  String? valueName;

  Parameter(
      {this.parameterName,
      this.parameterType,
      this.valueId,
      this.valueName,
      this.parameterId});

  factory Parameter.fromJson(Map<String, dynamic> json) => Parameter(
        parameterName: json["parameterName"],
        parameterType: json["parameterType"],
        parameterId: json['parameterId'],
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
