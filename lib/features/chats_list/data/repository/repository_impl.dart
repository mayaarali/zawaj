import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/features/chats_list/data/model/chats_model.dart';

class ChatRepository {
  final Dio dio;

  ChatRepository(this.dio);

  Future<List<Chat>> getChats() async {
    dio.interceptors.add(
      AwesomeDioInterceptor(
        logRequestTimeout: false,
        logRequestHeaders: false,
        logResponseHeaders: false,
      ),
    );
    try {
      String? token = await CacheHelper.getData(key: Strings.token);

      final response = await dio.get(
        '${EndPoints.BASE_URL}Chats/GetChats',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => Chat.fromJson(json)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }
}

// I/flutter (30304):   {
// I/flutter (30304):     "chatId": 56,
// I/flutter (30304):     "userId": "832acc34-8d76-4cea-9e8c-17b8a87efe02",
// I/flutter (30304):     "lastMessage": "tytyt",
// I/flutter (30304):     "lastMessageTime": " 1 day ago",
// I/flutter (30304):     "userName": null,
// I/flutter (30304):     "userImages": null,
// I/flutter (30304):     "unseenMessages": 1   },
