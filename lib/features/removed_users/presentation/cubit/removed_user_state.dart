part of 'removed_user_cubit.dart';

@immutable
abstract class RemovedUsersState {}

class RemovedUsersInitial extends RemovedUsersState {}

class RemovedUsersLoading extends RemovedUsersState {}

class RemovedUsersLoaded extends RemovedUsersState {
  final List<RemovedUsersEntity> users;

  RemovedUsersLoaded(this.users);
}

class RemovedUsersError extends RemovedUsersState {
  final String message;

  RemovedUsersError(this.message);
}
