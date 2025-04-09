import 'package:chalk/chalk.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/widgets/toast.dart';

class ApiExceptionHandler {
  static dynamic getMessage(error) {
    dynamic errorDescription = "";
    debugPrint('error type ===> $error');
    debugPrint('error type ===> ${error.runtimeType}');
    if (error == null) {
      errorDescription = Strings.went_wrong;
    } else {
      if (error.runtimeType == String) {
        errorDescription = error;
      } else {
        if (error is Exception) {
          try {
            if (error is DioException) {
              switch (error.type) {
                case DioExceptionType.cancel:
                  errorDescription = "Request to API server was cancelled";
                  break;
                case DioExceptionType.connectionTimeout:
                  errorDescription = Strings.timeout;
                  break;
                case DioExceptionType.unknown:
                  print(error.response);
                  print(error.response?.statusCode);
                  print(error.response?.statusMessage);
                  print('=================================================');
                  errorDescription =
                      "Connection to API server failed due to internet connection";
                  break;
                case DioExceptionType.receiveTimeout:
                  errorDescription =
                      "Receive timeout in connection with API server";
                  break;
                case DioExceptionType.badResponse:
                  switch (error.response?.statusCode) {
                    case 404:
                    case 500:
                      errorDescription = Strings.went_wrong;
                    case 503:
                    case 405:
                      print(error.response);
                      errorDescription = error.response?.statusMessage;
                      break;
                    case 403:
                    case 400:
                      errorDescription =
                          error.response?.data['message'].toString();

                      break;
                    case 401:
                      print('err 401');
                      //  showToast(msg: 'ERRRRROOOOOOOOORRRRRRRr');
                      print(error.response?.data);
                      break;
                    case 422:
                      print(error.response?.data);
                      print(error.response?.data.keys.first);
                      Map map;

                      print('iaaaaam in 422 erooooooor');
                      print('iaaaaam in 422 erooooooor');

                      errorDescription = error.response?.data.values.first[0];
                      break;

                    default:
                      errorDescription = Strings.fail_loading;
                  }
                  break;
                case DioExceptionType.sendTimeout:
                  errorDescription = Strings.went_wrong;
                  break;
                default:
                  errorDescription = Strings.no_internet;
                  break;
              }
            } else {
              errorDescription = Strings.unexpected_error;
            }
          } on FormatException catch (e) {
            errorDescription = e.toString();
          }
        } else {
          switch (error.statusCode) {
            case 404:
            case 500:
              errorDescription = Strings.went_wrong;
            case 503:
            case 405:
              errorDescription = error.data['message'];
              break;
            case 403:
            case 401:
              errorDescription = error.data['message'];
            //     showToast(msg: 'ERRRRROOOOOOOOORRRRRRRr');

            case 422:
              errorDescription = error.data['message'];
              break;
            case 400:
              errorDescription = error.data['errors'];
              break;
            default:
              errorDescription = Strings.fail_loading;
          }
        }
      }
    }

    debugPrint(chalk.red('error is=========>$errorDescription'));
    // showToast(msg: errorDescription);
    return errorDescription;
  }
}
