import 'dart:convert';

String resetPasswordToJson(List<ResetpasswordModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ResetpasswordModel {
  String? value;
  String? password;
  String? confirmPassword;
  String? code;

  ResetpasswordModel({
    this.value,
  });

  Map<String, dynamic> toJson() => {
        "value": value,
        "password": password,
        "confirmPassword": confirmPassword,
        "code": code,
      };
}
