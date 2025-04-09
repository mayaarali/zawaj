import 'package:equatable/equatable.dart';

class RemovedUsersEntity extends Equatable {
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

  const RemovedUsersEntity({
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

  @override
  List<Object?> get props => [
        userId,
        setupId,
        isLiked,
        isSubscribed,
        expiredDateSubscribe,
        name,
        about,
        city,
        area,
        gender,
        age,
        maritalStatus,
        height,
        weight,
        isSmoking,
        images,
        parameters,
      ];
}
