import 'package:dio/dio.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/helper/dio_helper.dart';

class AppRerportDataSourceImp {
  @override
  DioHelper apiClientHelper;
  AppRerportDataSourceImp({required this.apiClientHelper});

  Future appReport({required String message}) {
    return apiClientHelper.postData(
        url: EndPoints.appReport,
        data: FormData.fromMap({
          "Message": message,
        }));
  }
}
