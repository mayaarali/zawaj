import 'package:dio/dio.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/helper/dio_helper.dart';

class VerifyDataSourceImp {
  @override
  DioHelper apiClientHelper;
  VerifyDataSourceImp({required this.apiClientHelper});

  Future verification({
    required String image1,
    required String image2,
  }) async {
    return apiClientHelper.postData(
        url: EndPoints.verification,
        data: FormData.fromMap({
          "PersonImage": await MultipartFile.fromFile(image1),
          "IdImage": await MultipartFile.fromFile(image2),
        }));
  }
}
