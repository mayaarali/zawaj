part of 'who_like_me_bloc.dart';

abstract class WhoLikeMeState {}

final class WhoLikeMeInitial extends WhoLikeMeState {}

final class WhoLikeMeLoading extends WhoLikeMeState {}

final class WhoLikeMeSuccess extends WhoLikeMeState {
  List<HomeModel> homeModel;
  WhoLikeMeSuccess(this.homeModel);
}

final class WhoLikeMeFailure extends WhoLikeMeState {
  String mesaage;
  WhoLikeMeFailure({required this.mesaage});
}

final class AllNotificationInitial extends WhoLikeMeState {}

final class AllNotificationLoading extends WhoLikeMeState {}

final class AllNotificationSuccess extends WhoLikeMeState {
  List<NotificationModel> notificationModel;
  AllNotificationSuccess(this.notificationModel);
}

final class AllNotificationFailure extends WhoLikeMeState {
  String mesaage;
  AllNotificationFailure({required this.mesaage});
}
