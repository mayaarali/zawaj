import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/helper/dio_helper.dart';

class WhoLikedMeDataSourceImp {
  @override
  DioHelper apiClientHelper;
  WhoLikedMeDataSourceImp({required this.apiClientHelper});

  Future whoLikedMe() {
    return apiClientHelper.getData(url: EndPoints.whoLikedMe);
  }

  Future allNotifications() {
    return apiClientHelper.getData(url: EndPoints.getNotifications);
  }
}
