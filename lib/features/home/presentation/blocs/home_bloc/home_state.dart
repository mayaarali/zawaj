part of 'home_bloc.dart';

abstract class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeSuccess extends HomeState {
  List<HomeModel> homeList;
  HomeSuccess(this.homeList);
}

final class HomeFailure extends HomeState {
  String message;
  HomeFailure({required this.message});
}

final class IsLikedPostLoading extends HomeState {}

final class IsLikedPostSuccess extends HomeState {
  String message;
  IsLikedPostSuccess({required this.message});
}

final class IsLikedPostFailure extends HomeState {
  String message;
  IsLikedPostFailure({required this.message});
}

final class IsLoading extends HomeState {}

final class IsDisLikedPostLoading extends HomeState {}
//
// final class IsDisLikedPostSuccess extends HomeState {
//   String message;
//   IsDisLikedPostSuccess({required this.message});
// }
//
// final class IsDisLikedPostFailure extends HomeState {
//   String message;
//   IsDisLikedPostFailure({required this.message});
// }

final class PartnerDetailsInitial extends HomeState {}

final class PartnerDetailsLoading extends HomeState {}

final class PartnerDetailsSuccess extends HomeState {
  List<HomeModel> homeList;
  PartnerDetailsSuccess(this.homeList);
}

final class PartnerDetailsFailure extends HomeState {
  final String message;
  PartnerDetailsFailure({required this.message});
}

final class RemoveUserLoading extends HomeState {}

final class RemoveUserSuccess extends HomeState {
  String message;
  RemoveUserSuccess({required this.message});
}

final class RemoveUserFailure extends HomeState {
  String message;
  RemoveUserFailure({required this.message});
}
