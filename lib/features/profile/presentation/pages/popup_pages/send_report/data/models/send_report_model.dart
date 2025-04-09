import 'dart:convert';

String reportModelToJson(List<ReportModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReportModel {
  int? userId;
  String? reason;
  String? reportMessage;

  ReportModel({this.userId, this.reason, this.reportMessage});

  Map<String, dynamic> toJson() => {
        "UserId": userId,
        "Reason": reason,
        "ReportMessage": reportMessage,
      };
}
