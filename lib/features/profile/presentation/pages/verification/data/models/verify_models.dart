import 'dart:convert';

String verifyModelToJson(List<VerifyModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VerifyModel {
  String? image1;
  String? image2;

  VerifyModel({this.image1, this.image2});

  Map<String, dynamic> toJson() => {
        "Image1": image1,
        "Image2": image2,
      };
}
