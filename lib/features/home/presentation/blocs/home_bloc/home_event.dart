part of 'home_bloc.dart';

abstract class HomeEvent {}

class GetPartnerData extends HomeEvent {}

class LikePostEvent extends HomeEvent {
  String userId;
  LikePostEvent({required this.userId});
}

class DisLikePostEvent extends HomeEvent {
  String userId;
  DisLikePostEvent({required this.userId});
}

class PartnerDetailsEvent extends HomeEvent {}

class RemoveUserEvent extends HomeEvent {
  String userId;
  RemoveUserEvent({required this.userId});
}
