import 'dart:io';

import 'package:zawaj/features/update_profile_picture/data/update_profile_picture_repository.dart';
import 'package:zawaj/features/update_profile_picture/domain/useCase/update_profile_picture_use_case.dart';

class ConcreteUpdateProfilePictureUseCase
    implements UpdateProfilePictureUseCase {
  final UpdateProfilePictureRepository _repository;

  ConcreteUpdateProfilePictureUseCase(this._repository);

  @override
  Future<void> execute(
      {required List<File> imageFiles,
      required List<String> existingImagePaths}) {
    return _repository.updateProfilePictures(
        imageFiles: imageFiles, existingImagePaths: existingImagePaths);
  }
}
