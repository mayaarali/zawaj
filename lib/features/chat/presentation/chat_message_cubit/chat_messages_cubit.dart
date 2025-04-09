import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/features/chat/domain/get_chat_messages_usecase.dart';
import 'package:zawaj/features/chat/presentation/chat_message_cubit/chat_messages_states.dart';

class ChatMessagesCubit extends Cubit<ChatMessagesState> {
  final GetChatMessagesDataUseCase _getChatMessagesDataUseCase;
  final Dio dio = Dio();

  ChatMessagesCubit(this._getChatMessagesDataUseCase)
      : super(ChatMessagesLoadingState());

  Future<void> getChatMessagesData(String user2Id,
      {int page = 1, int pageSize = 10}) async {
    try {
      final chatData = await _getChatMessagesDataUseCase(user2Id,
          page: page, pageSize: pageSize);
      emit(ChatMessagesLoadedState(chatData));
    } catch (e) {
      emit(ChatMessagesErrorState('Failed to fetch chat data: $e'));
    }
  }

  Future<void> deleteMessage(int messageId) async {
    String? token = await CacheHelper.getData(key: Strings.token);
    // dio.interceptors.add(
    //   AwesomeDioInterceptor(
    //     logRequestTimeout: false,
    //     logRequestHeaders: false,
    //     logResponseHeaders: false,
    //   ),
    // );
    try {
      final response = await dio.put(
        '${EndPoints.BASE_URL}Chats/DeleteMessage?MessageId=$messageId',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      if (response.statusCode == 200) {
        //emit(MessageDeleted());
      } else {
        // emit(MessageDeletionError());
      }
    } catch (e) {
      //emit(MessageDeletionError());
    }
  }

  Future<void> endChat({required chatId, required String reason}) async {
    String? token = await CacheHelper.getData(key: Strings.token);

    try {
      dio.interceptors.add(
        AwesomeDioInterceptor(
          logRequestTimeout: false,
          logRequestHeaders: false,
          logResponseHeaders: false,
        ),
      );
      final response = await dio.put(
        '${EndPoints.BASE_URL}Chats/EndChat',
        queryParameters: {
          'ChatId': chatId,
          'Reason': reason,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      if (response.statusCode == 200) {
      } else {}
    } catch (e) {}
  }

  Future<String?> extensionChatRequest({
    required chatId,
    required String reason,
  }) async {
    String? token = await CacheHelper.getData(key: Strings.token);

    try {
      dio.interceptors.add(
        AwesomeDioInterceptor(
          logRequestTimeout: false,
          logRequestHeaders: false,
          logResponseHeaders: false,
        ),
      );
      final response = await dio.post(
        '${EndPoints.BASE_URL}Chats/ExtensionChatRequest',
        queryParameters: {
          'ChatId': chatId,
          'Reason': reason,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      if (response.statusCode == 200) {
        final responseData = response.data;
        return responseData['message'];
      } else {
        return 'خطأ في الطلب';
      }
    } catch (e) {
      return 'ارسلت بالفعل طلب لمد هذه المحادثة';
    }
  }



  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool isGiphyLink(String messageContent) {
    return messageContent.contains("https://giphy.com/embed/");
  }

  bool isVideoLink(String messageContent) {
    return messageContent.contains(EndPoints.BASE_URL_image);
  }
}
