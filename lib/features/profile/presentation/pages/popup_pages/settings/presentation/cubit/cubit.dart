import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/features/profile/presentation/bloc/profile_bloc.dart';

class NotificationsToggleCubit extends Cubit<Map<String, bool>> {
  NotificationsToggleCubit() : super({});
  bool isloading = false;
  bool stoploading = true;
  void toggleFeature(String feature, bool isEnabled, context) async {
    final dio = Dio();
    dio.interceptors.add(
      AwesomeDioInterceptor(
        logRequestTimeout: false,
        logRequestHeaders: false,
        logResponseHeaders: false,
        logger: debugPrint,
      ),
    );
    String? token = await CacheHelper.getData(key: Strings.token);

    try {
      String endpoint;
      switch (feature) {
        case 'notification':
          endpoint = '${EndPoints.BASE_URL}${EndPoints.toggleNotificationApp}';
          break;
        case 'like':
          endpoint = '${EndPoints.BASE_URL}${EndPoints.toggleLike}';
          break;
        case 'message':
          endpoint = '${EndPoints.BASE_URL}${EndPoints.toglleMessage}';
          break;
        default:
          throw Exception('Unsupported feature');
      }

      await dio.put(
        endpoint,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      await ProfileBloc.get(context).getMyProfile();
      isloading = false;
      emit(state..[feature] = isEnabled);
    } catch (e) {
      emit(state..[feature] = !isEnabled);
    }
  }
}
