import 'dart:convert';

String socialLoginModelToJson(List<SocialloginModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SocialloginModel {
  String? email;
  String? name;
  String? uniqueId;

  String? providerPlatform;

  SocialloginModel({
    this.email,
    this.name,
    this.uniqueId,
    this.providerPlatform,
  });

  Map<String, dynamic> toJson() => {
        "Email": email,
        "Name": name,
        "UniqueId": uniqueId,
        "ProviderPlatform": providerPlatform,
      };
}
