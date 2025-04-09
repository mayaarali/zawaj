import 'dart:async';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/features/chats_list/data/model/chats_model.dart';
import 'package:zawaj/features/chats_list/domain/reposiory/repository.dart';
import 'package:zawaj/features/chats_list/presentation/cubit/get_chats_statets.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final GetChats getChats;
  late StreamSubscription<List<Chat>> _chatsSubscription;
  late StreamController<List<Chat>> _chatsController;
  final Dio dio = Dio();
  Timer? _timer;

  ChatsCubit(this.getChats) : super(ChatsInitial()) {
    _chatsController = StreamController<List<Chat>>.broadcast();

    _chatsSubscription = _chatsController.stream.listen((chats) {
      emit(ChatsLoaded(chats));
    });

    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      fetchChats();
    });

    fetchChats();
  }

  Stream<List<Chat>> get chatsStream => _chatsController.stream;

  @override
  Future<void> close() {
    _chatsSubscription.cancel();
    _chatsController.close();
    _timer?.cancel();
    return super.close();
  }

  Future<void> fetchChats() async {
    emit(ChatsLoading());
    try {
      final Either<Exception, List<Chat>> result = await getChats();
      result.fold(
        (error) {
          log('Error fetching chats: $error');
          emit(const ChatsError(
              'Failed to load chats. Please check your internet connection and try again.'));
        },
        (chats) {
          _chatsController.add(chats);
          emit(ChatsLoaded(chats));
        },
      );
    } catch (error) {
      // Handle any unexpected errors
      log('Unexpected error fetching chats: $error');
      emit(const ChatsError(
          'An unexpected error occurred. Please try again later.'));
    }
  }

  Future<void> pinChat(int chatId) async {
    try {
      String? token = await CacheHelper.getData(key: Strings.token);

      await dio.put(
        '${EndPoints.BASE_URL}Chats/PinChat?ChatId=$chatId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (error) {
      log('Error pinning chat: $error');
    }
  }

  Future<void> unpinChat(int chatId) async {
    try {
      String? token = await CacheHelper.getData(key: Strings.token);

      await dio.put(
        '${EndPoints.BASE_URL}Chats/UnPinChat?ChatId=$chatId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (error) {
      log('Error unpinning chat: $error');
    }
  }

  Future<void> outChat() async {
    String? token = await CacheHelper.getData(key: Strings.token);
    try {
      final response = await dio.post(
        '${EndPoints.BASE_URL}Chats/OutChat',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      if (response.statusCode == 200) {
        // emit(ChatOutSuccessState());
      } else {
        // emit(ChatOutErrorState());
      }
    } catch (e) {
      //emit(ChatOutErrorState());
    }
  }

  Future<void> onChat() async {
    String? token = await CacheHelper.getData(key: Strings.token);
    try {
      final response = await dio.post(
        '${EndPoints.BASE_URL}Chats/OnChat',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      if (response.statusCode == 200) {
        // emit(ChatOnSuccessState());
      } else {
        // emit(ChatOnErrorState());
      }
    } catch (e) {
      //emit(ChatOnErrorState());
    }
  }
}
