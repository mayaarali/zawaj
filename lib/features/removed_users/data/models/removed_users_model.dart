import 'package:zawaj/features/removed_users/domain/entities/removed_user_entity.dart';

class RemovedUsersModel {
  final String userId;
  final int setupId;
  final bool isLiked;
  final bool isSubscribed;
  final String? expiredDateSubscribe;
  final String name;
  final String about;
  final String city;
  final String area;
  final String gender;
  final int age;
  final String maritalStatus;
  final double height;
  final double weight;
  final bool isSmoking;
  final List<String> images;
  final List<dynamic> parameters;

  RemovedUsersModel({
    required this.userId,
    required this.setupId,
    required this.isLiked,
    required this.isSubscribed,
    required this.expiredDateSubscribe,
    required this.name,
    required this.about,
    required this.city,
    required this.area,
    required this.gender,
    required this.age,
    required this.maritalStatus,
    required this.height,
    required this.weight,
    required this.isSmoking,
    required this.images,
    required this.parameters,
  });
  RemovedUsersEntity toEntity() {
    return RemovedUsersEntity(
      userId: userId,
      setupId: setupId,
      isLiked: isLiked,
      isSubscribed: isSubscribed,
      expiredDateSubscribe: expiredDateSubscribe,
      name: name,
      about: about,
      city: city,
      area: area,
      gender: gender,
      age: age,
      maritalStatus: maritalStatus,
      height: height,
      weight: weight,
      isSmoking: isSmoking,
      images: images,
      parameters: parameters,
    );
  }

  factory RemovedUsersModel.fromJson(Map<String, dynamic> json) {
    return RemovedUsersModel(
      userId: json['userId'],
      setupId: json['setupId'],
      isLiked: json['isLiked'],
      isSubscribed: json['isSubscribed'],
      expiredDateSubscribe: json['expiredDateSubscribe'],
      name: json['name'],
      about: json['about'] ?? '',
      city: json['city'],
      area: json['area'],
      gender: json['gender'],
      age: json['age'],
      maritalStatus: json['maritalStatus'],
      height: json['height'],
      weight: json['weight'],
      isSmoking: json['isSmoking'],
      images: List<String>.from(json['images']),
      parameters: json['parameters'],
    );
  }
}
