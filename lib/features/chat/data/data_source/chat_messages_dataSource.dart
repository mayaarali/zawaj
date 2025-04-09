import 'dart:convert';
import 'dart:developer';

import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/helper/cache_helper.dart';

class ChatDataProvider {
  final Dio _dio = Dio();
  final String baseUrl = '${EndPoints.BASE_URL}Chats';

  ChatDataProvider();

  Future<Map<String, dynamic>> fetchChatData(String user2Id,
      {int page = 1, int pageSize = 10}) async {
    try {
      String? token = await CacheHelper.getData(key: Strings.token);

      final response = await _dio.get(
        '$baseUrl/GetChat?User2Id=$user2Id&page=$page&pageSize=$pageSize',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}
