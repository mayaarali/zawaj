import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/helper/api_error_handler.dart';
import 'package:zawaj/core/network/network_info.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/send_report/data/data_source/send_report_datascource.dart';

class SendReportRepositortyImp {
  SendRerportDataSourceImp sendRerportDataSourceImp;
  NetworkInfo networkInfo;
  SendReportRepositortyImp({
    required this.sendRerportDataSourceImp,
    required this.networkInfo,
  });
  Future<Either<String, String>> sendReport({
    required String userId,
    required String userName,
    required String reason,
    required String reportMessage,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await sendRerportDataSourceImp.sendReport(
            userId: userId,
            reason: reason,
            reportMessage: reportMessage,
            userName: userName);

        if (response.statusCode == 200) {
          // response.data!.forEach((e) {
          //   paramsList.add(ParamsModel.fromJson(e)); });
          //CacheHelper.setUserData(registerResponse.user!);

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
