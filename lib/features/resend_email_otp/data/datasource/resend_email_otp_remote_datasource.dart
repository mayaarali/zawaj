import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/core/helper/dio_helper.dart';
import 'package:zawaj/features/resend_email_otp/data/model/resend_email_otp_response_model.dart';

abstract class ResendEmailOtpRemoteDataSource {
  Future<OtpResponseModel> resendOtp();
}

class ResendEmailOtpRemoteDataSourceImpl implements ResendEmailOtpRemoteDataSource {
  final Dio dio;
  final bool isEmailOtp;

  ResendEmailOtpRemoteDataSourceImpl({required this.dio, required this.isEmailOtp, required Type remoteDataSource});

  @override
  Future<OtpResponseModel> resendOtp() async {
    String? token = await CacheHelper.getData(key: Strings.token);
    dio.interceptors.add(
      AwesomeDioInterceptor(
        logRequestTimeout: false,
        logRequestHeaders: false,
        logResponseHeaders: false,
        logger: debugPrint,
      ),
    );

    String endpoint = isEmailOtp ? '${EndPoints.BASE_URL}Account/ResendEmailOtp' : '${EndPoints.BASE_URL}Account/ResendPhoneOtp';

    final response = await dio.post(
      endpoint,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200) {
      return OtpResponseModel.fromJson(response.data);
    } else {
      throw Exception('Failed to resend OTP');
    }
  }
}
