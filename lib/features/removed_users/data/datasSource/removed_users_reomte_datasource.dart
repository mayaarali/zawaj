import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/helper/cache_helper.dart';

class RemovedUsersRemoteDataSource {
  final Dio dio;

  RemovedUsersRemoteDataSource(this.dio);

  Future<List<Map<String, dynamic>>> fetchUsers(int page) async {
    dio.interceptors.add(
      AwesomeDioInterceptor(
        logRequestTimeout: false,
        logRequestHeaders: false,
        logResponseHeaders: false,
      ),
    );

    String? token = await CacheHelper.getData(key: Strings.token);

    try {
      final response = await dio.get(
        '${EndPoints.BASE_URL}HomeUser/GetRemovedUsers?Page=$page&PagesLimit=10&lang=en',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final List<dynamic> responseData = response.data;
      return List<Map<String, dynamic>>.from(responseData);
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }
}
