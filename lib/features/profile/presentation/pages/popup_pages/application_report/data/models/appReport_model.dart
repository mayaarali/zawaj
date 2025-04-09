import 'dart:convert';

String appReportModelToJson(List<AppReportModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AppReportModel {
  String? message;

  AppReportModel({this.message});

  Map<String, dynamic> toJson() => {
        "Message": message,
      };
}
