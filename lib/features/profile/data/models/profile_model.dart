import 'package:zawaj/features/profile/data/models/partner_model.dart';

class ProfileData {
  String? id;
  String? chatUserId;
  String? verificationStatus;
  String? userId;
  bool? likeSetting;
  bool? notificationSetting;
  bool? messageSetting;
  bool? isSubscribed;
  String? expiredDateSubscribe;
  String? name;
  String? about;
  String? city;
  String? area;
  String? gender;
  int? age;
  int? hasChat;
  int? cityId;
  int? areaId;
  String? maritalStatus;
  int? maritalStatusId;
  String? religion;
  String? birthDay;
  double? height;
  double? weight;
  bool? isSmoking;
  List<String>? images;
  List<Parameter>? parameters;

  ProfileData(
      {this.id,
      this.verificationStatus,
      this.chatUserId,
      this.userId,
      this.expiredDateSubscribe,
      this.likeSetting,
      this.isSubscribed,
      this.notificationSetting,
      this.messageSetting,
      this.name,
      this.about,
      this.city,
      this.area,
      this.hasChat,
      this.gender,
      this.age,
      this.maritalStatus,
      this.height,
      this.weight,
      this.isSmoking,
      this.images,
      this.parameters,
      this.religion,
      this.areaId,
      this.cityId,
      this.birthDay,
      this.maritalStatusId});

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        id: json["id"],
        chatUserId: json["chatUserId"],
        isSubscribed: json["isSubscribed"],
        religion: json["religion"],
        cityId: json["cityId"],
        areaId: json["areaId"],
        verificationStatus: json["verificationStatus"],
        userId: json["id"],
        expiredDateSubscribe: json["expiredDateSubscribe"],
        likeSetting: json["likeSetting"],
        notificationSetting: json["notificationSetting"],
        messageSetting: json["messageSetting"],
        name: json["name"],
        about: json["about"],
        city: json["city"],
        area: json["area"],
        gender: json["gender"],
        age: json["age"],
        hasChat: json["hasChat"],
        maritalStatusId: json["maritalStatusId"],
        maritalStatus: json["maritalStatus"],
        birthDay: json["birthDay"],
        height: json["height"]?.toDouble(),
        weight: json["weight"]?.toDouble(),
        isSmoking: json["isSmoking"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
        parameters: json["parameters"] == null
            ? []
            : List<Parameter>.from(
                json["parameters"]!.map((x) => Parameter.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "chatUserId": chatUserId,
        "isSubscribed": isSubscribed,
        "religion": religion,
        "hasChat": hasChat,
        'expiredDateSubscribe': expiredDateSubscribe,
        "verificationStatus": verificationStatus,
        "userId": userId,
        "likeSetting": likeSetting,
        "notificationSetting": notificationSetting,
        "messageSetting": messageSetting,
        "name": name,
        "about": about,
        "city": city,
        "area": area,
        "gender": gender,
        "age": age,
        "birthDay": birthDay,
        "maritalStatusId": maritalStatusId,
        "maritalStatus": maritalStatus,
        "height": height,
        "weight": weight,
        "isSmoking": isSmoking,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "parameters": parameters == null
            ? []
            : List<dynamic>.from(parameters!.map((x) => x.toJson())),
      };
}
