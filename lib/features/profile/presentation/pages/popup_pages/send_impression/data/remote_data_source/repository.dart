import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/send_impression/data/model/model.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/send_impression/domin/repository.dart';

class AppFeedbackRepository implements AppFeedbackRepositoryImpl {
  final Dio _dio;

  AppFeedbackRepository(this._dio);

  @override
  Future<void> sendFeedback(AppFeedback feedback) async {
    _dio.interceptors.add(
      AwesomeDioInterceptor(
        logRequestTimeout: false,
        logRequestHeaders: false,
        logResponseHeaders: false,
        logger: debugPrint,
      ),
    );
    String? token = await CacheHelper.getData(key: Strings.token);

    try {
      FormData formData = FormData.fromMap({
        'Message': feedback.message,
      });

      await _dio.post(
        '${EndPoints.BASE_URL}${EndPoints.addFeedbackApplication}',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to send feedback');
    }
  }
}
