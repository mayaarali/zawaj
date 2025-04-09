import 'package:dio/dio.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/helper/dio_helper.dart';

class HomeDataSourceImp {
  DioHelper apiClientHelper;
  HomeDataSourceImp({required this.apiClientHelper});

  Future<Response> getPartnerData({int page = 1, int pageLimit = 10}) {
    return apiClientHelper.getData(
        url: 'homeUser/GetMatching?Page=$page&PagesLimit=$pageLimit&lang=ar');
  }

  isPostLiked({required String userId}) {
    return apiClientHelper.postData(url: EndPoints.LikedPost, query: {
      "UserId": userId,
    });
  }

  isPostDisliked({required String userId}) {
    return apiClientHelper.deleteData(url: EndPoints.disLikePost, query: {
      "userId": userId,
    });
  }

  removeUser({required String userId}) {
    return apiClientHelper.postData(url: EndPoints.remove_user, query: {
      "userId": userId,
    });
  }
}
