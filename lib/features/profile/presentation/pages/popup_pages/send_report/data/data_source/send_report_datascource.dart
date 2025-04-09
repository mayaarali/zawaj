import 'package:dio/dio.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/helper/dio_helper.dart';

class SendRerportDataSourceImp {
  @override
  DioHelper apiClientHelper;
  SendRerportDataSourceImp({required this.apiClientHelper});

  Future sendReport(
      {required String userId,
      required String userName,
      required String reason,
      required String reportMessage}) {
    return apiClientHelper.postData(
        url: EndPoints.send_report,
        query: {
          "UserId": userId,
        },
        data: FormData.fromMap({
          "Reason": reason,
          "ReportMessage": reportMessage,
          "UserName": userName
        }));
  }
}
