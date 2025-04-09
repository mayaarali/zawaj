import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/features/home/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:zawaj/features/removed_users/presentation/cubit/removed_user_cubit.dart';

enum UnRemoveUserState { initial, loading, success, error }

class UnRemoveUserCubit extends Cubit<UnRemoveUserState> {
  UnRemoveUserCubit() : super(UnRemoveUserState.initial);

  Future<void> removeUser(String userId) async {
    final Dio dio = Dio();
    emit(UnRemoveUserState.loading);
    String? token = await CacheHelper.getData(key: Strings.token);
    dio.interceptors.add(
      AwesomeDioInterceptor(
        logRequestTimeout: false,
        logRequestHeaders: false,
        logResponseHeaders: false,
        logger: debugPrint,
      ),
    );
    try {
      final response = await dio.delete(
        '${EndPoints.BASE_URL}HomeUser/UnRemoveUser?UserId=$userId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        emit(UnRemoveUserState.success);
      } else {
        emit(UnRemoveUserState.error);
      }
    } catch (e) {
      emit(UnRemoveUserState.error);
    }
  }
}
