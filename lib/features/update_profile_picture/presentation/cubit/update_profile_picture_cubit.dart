import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/features/update_profile_picture/domain/useCase/update_profile_picture_use_case.dart';
part 'update_profile_picture_state.dart';

class UpdateProfilePictureCubit extends Cubit<UpdateProfilePictureState> {
  final UpdateProfilePictureUseCase _updateProfilePictureUseCase;

  UpdateProfilePictureCubit(this._updateProfilePictureUseCase)
      : super(UpdateProfilePictureInitial());

  Future<void> updateProfilePictures(
      {required List<File> imageFiles,
      required List<String> existingImagePaths}) async {
    emit(UpdateProfilePictureLoading());
    try {
      await _updateProfilePictureUseCase.execute(
          imageFiles: imageFiles, existingImagePaths: existingImagePaths);
      emit(UpdateProfilePictureSuccess());
    } catch (e) {
      log('Failed to update profile pictures: $e');
      emit(UpdateProfilePictureError('Failed to update profile pictures: $e'));
    }
  }
}
