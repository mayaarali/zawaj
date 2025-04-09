import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/features/profile/presentation/pages/edit_profile/about_me/data/model/model.dart';

class AboutCubit extends Cubit<AboutState> {
  AboutCubit() : super(AboutInitial());
  bool isLoading = false;
  void addAbout(AboutMeData data) async {
    final dio = Dio();

    String? token = await CacheHelper.getData(key: Strings.token);
    isLoading = true;
    emit(AboutLoading());
    try {
      FormData formData = FormData.fromMap({
        'About': data.about,
      });
      await dio.put(
        '${EndPoints.BASE_URL}${EndPoints.aboutMe}',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      isLoading = false;
      emit(AboutSuccess());
    } catch (e) {
      isLoading = false;
      emit(AboutError(e.toString()));
    }
  }
}

abstract class AboutState {}

class AboutInitial extends AboutState {}

class AboutLoading extends AboutState {}

class AboutSuccess extends AboutState {}

class AboutError extends AboutState {
  final String message;

  AboutError(this.message);
}

abstract class AboutEvent {}

class AddAbout extends AboutEvent {
  final AboutMeData data;

  AddAbout(this.data);
}
