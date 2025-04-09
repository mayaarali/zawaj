import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/helper/cache_helper.dart';

part 'edit_image_and_name_state.dart';

class EditImageAndNameCubit extends Cubit<EditImageAndNameState> {
  final Dio _dio;

  EditImageAndNameCubit(this._dio) : super(EditImageAndNameInitial());

  void replaceImage(int index, XFile image) {
    emit(EditImageAndNameImageReplaced(index, image));
  }

  Future<void> updateProfile(String name, List<XFile> newImages,
      List<String> existingImages, Map<int, XFile> replacedImages) async {
    emit(EditImageAndNameLoading());
    String? token = await CacheHelper.getData(key: Strings.token);

    try {
      var formData = FormData();

      formData.fields.add(MapEntry('Name', name));

      // Exclude replaced images from existing images
      final filteredExistingImages = existingImages.where((image) {
        return !replacedImages.keys.contains(existingImages.indexOf(image));
      }).toList();

      // Add remaining existing images to form data
      for (var image in filteredExistingImages) {
        formData.fields.add(MapEntry('ExistImagesPath', image));
      }

      // Add new images
      for (var image in newImages) {
        formData.files.add(MapEntry(
          'ImagesPath',
          await MultipartFile.fromFile(image.path),
        ));
      }

      // Treat replaced images as new images
      for (var entry in replacedImages.entries) {
        formData.files.add(MapEntry(
          'ImagesPath',
          await MultipartFile.fromFile(entry.value.path),
        ));
      }

      _dio.interceptors.add(
        AwesomeDioInterceptor(
          logRequestTimeout: false,
          logRequestHeaders: false,
          logResponseHeaders: false,
        ),
      );

      final response = await _dio.put(
        '${EndPoints.BASE_URL}HomeUser/UpdateProfilePictureAndImage',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        emit(EditImageAndNameUpdated());
      } else {
        emit(EditImageAndNameError('Failed to update profile'));
      }
    } catch (e) {
      emit(EditImageAndNameError(e.toString()));
    }
  }
}
