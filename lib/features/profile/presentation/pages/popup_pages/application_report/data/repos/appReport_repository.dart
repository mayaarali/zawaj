import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/helper/api_error_handler.dart';
import 'package:zawaj/core/network/network_info.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/application_report/data/dataSorce/appReprt_dataSorce.dart';

class AppReportRepositortyImp {
  AppRerportDataSourceImp appRerportDataSourceImp;
  NetworkInfo networkInfo;
  AppReportRepositortyImp({
    required this.appRerportDataSourceImp,
    required this.networkInfo,
  });
  Future<Either<String, String>> appReport({
    required String message,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        Response response =
            await appRerportDataSourceImp.appReport(message: message);

        if (response.statusCode == 200) {
          return const Right(Strings.login_success);
        } else {
          return Left(ApiExceptionHandler.getMessage(response));
        }
      } on DioException catch (error) {
        return Left(ApiExceptionHandler.getMessage(error));
      }
    } else {
      return const Left(Strings.nointernet);
    }
  }
}
