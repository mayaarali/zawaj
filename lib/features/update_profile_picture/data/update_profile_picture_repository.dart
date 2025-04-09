// data/update_profile_picture_repository.dart

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/helper/cache_helper.dart';

class UpdateProfilePictureRepository {
  final Dio _dio = Dio();

  Future<void> updateProfilePictures(
      {required List<File> imageFiles,
      required List<String> existingImagePaths}) async {
    String? token = await CacheHelper.getData(key: Strings.token);

    try {
      var formData = FormData();

      for (var file in imageFiles) {
        formData.files.add(MapEntry(
          'ImagesPath',
          await MultipartFile.fromFile(file.path),
        ));
      }

      formData.fields.add(MapEntry(
        'ExistImagesPath',
        existingImagePaths.join(','),
      ));

      _dio.interceptors.add(
        AwesomeDioInterceptor(
          logRequestTimeout: false,
          logRequestHeaders: false,
          logResponseHeaders: false,
          logger: debugPrint,
        ),
      );

      final response = await _dio.put(
        '${EndPoints.BASE_URL}HomeUser/UpdateProfilePicture',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update profile pictures');
      }
    } catch (e) {
      throw Exception('Failed to update profile pictures: $e');
    }
  }
}
