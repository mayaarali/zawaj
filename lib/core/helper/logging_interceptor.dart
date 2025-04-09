import 'dart:developer';

import 'package:chalk/chalk.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class LoggingInterceptor extends InterceptorsWrapper {
  int maxCharactersPerLine = 200;

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    debugPrint(chalk.blue("--> ${options.method} ${options.path}"));
    debugPrint("Headers: ${options.headers.toString()}");
    debugPrint("<-- END HTTP");

    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    debugPrint(
        "<-- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}");

    String responseAsString = response.data.toString();
    log(chalk.yellow(response.data.toString()));
    // if (responseAsString.length > maxCharactersPerLine) {
    //   int iterations = (responseAsString.length / maxCharactersPerLine).floor();
    //   for (int i = 0; i <= iterations; i++) {
    //     int endingIndex = i * maxCharactersPerLine + maxCharactersPerLine;
    //     if (endingIndex > responseAsString.length) {
    //       endingIndex = responseAsString.length;
    //     }
    //     debugPrint(
    //         responseAsString.substring(i * maxCharactersPerLine, endingIndex));
    //   }
    // } else {
    //   log(response.data.toString());
    // }

    debugPrint("<-- END HTTP");

    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint(chalk.red(
        "ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}"));
    debugPrint(chalk.red("-->${err.response}"));

    return super.onError(err, handler);
  }
}
