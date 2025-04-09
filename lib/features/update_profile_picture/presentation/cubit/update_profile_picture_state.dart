part of 'update_profile_picture_cubit.dart';

abstract class UpdateProfilePictureState {}

class UpdateProfilePictureInitial extends UpdateProfilePictureState {}

class UpdateProfilePictureLoading extends UpdateProfilePictureState {}

class UpdateProfilePictureError extends UpdateProfilePictureState {
  final String message;

  UpdateProfilePictureError(this.message);
}

class UpdateProfilePictureSuccess extends UpdateProfilePictureState {}
