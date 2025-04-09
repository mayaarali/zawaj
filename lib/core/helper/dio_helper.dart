import 'dart:developer';

import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:zawaj/core/constants/strings.dart';
import '../constants/end_points.dart';
import 'cache_helper.dart';
import 'logging_interceptor.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    LoggingInterceptor loggingInterceptor = LoggingInterceptor();

    dio = Dio(
      BaseOptions(
        baseUrl: EndPoints.BASE_URL,
        receiveDataWhenStatusError: true,
      ),
    );
    //dio.interceptors.add(loggingInterceptor);
  }

  Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers = await getHeaders();
    dio.interceptors.add(
      AwesomeDioInterceptor(
        logRequestTimeout: false,
        logRequestHeaders: false,
        logResponseHeaders: false,
      ),
    );
    Response response = await dio.get(
      url,
      queryParameters: query,
    );

    return response;
  }

  postData({
    required String url,
    Map<String, dynamic>? query,
    dynamic data,
    String? token,
  }) async {
    dio.options.headers = await getHeaders();
    log('poooooooooost req');
    dio.interceptors.add(
      AwesomeDioInterceptor(
        logRequestTimeout: false,
        logRequestHeaders: false,
        logResponseHeaders: false,
      ),
    );
    log(data.toString());

    return dio.post(
      url,
      queryParameters: query,
      data: data,
      options: Options(
        followRedirects: false,
      ),
    );
  }

  Future<Response> putData(
      {required String url,
      Map<String, dynamic>? query,
      dynamic data,
      String? token,
      Map<String, dynamic>? headers}) async {
    debugPrint(data.toString());
    dio.options.headers = await getHeaders();
    dio.interceptors.add(
      AwesomeDioInterceptor(
        logRequestTimeout: false,
        logRequestHeaders: false,
        logResponseHeaders: false,
      ),
    );
    return dio.put(
      url,
      queryParameters: query,
      data: data,
      options: Options(
        followRedirects: false,
      ),
    );
  }

  Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
    String? token,
  }) async {
    debugPrint(data.toString());
    dio.options.headers = await getHeaders();
    return dio.delete(
      url,
      queryParameters: query,
      data: data,
      options: Options(
        followRedirects: false,
      ),
    );
  }

  Future<Map<String, dynamic>> getHeaders() async {
    String language =
        await CacheHelper.getData(key: Strings.language) == 'en' ? 'en' : 'ar';

    String? token = await CacheHelper.getData(key: Strings.token);
    print(token);
    Map<String, dynamic> headers = {
      //'Accept': 'application/json',
      // 'Accept-Language': language,
      //'Connection': 'keep-alive',
      'Content-Type': null,
    };

    if (token != null) {
      headers.addEntries({"Authorization": 'Bearer $token'}.entries);
    }
    return headers;
  }
}
