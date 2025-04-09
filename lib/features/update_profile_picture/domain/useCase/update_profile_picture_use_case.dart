import 'dart:io';

abstract class UpdateProfilePictureUseCase {
  Future<void> execute(
      {required List<File> imageFiles,
      required List<String> existingImagePaths});
}
