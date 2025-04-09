import 'package:zawaj/core/helper/dio_helper.dart';

class LikedPartnersDataSourceImp {
  @override
  DioHelper apiClientHelper;
  LikedPartnersDataSourceImp({required this.apiClientHelper});

  Future likedPartners({int page = 1, int pageLimit = 10}) {
    return apiClientHelper.getData(
        url:
            'HomeUser/GetMatchingLiked?Page=$page&PagesLimit=$pageLimit&lang=ar'
        //  'HomeUser/GetMatchingLiked'
        );
  }
}
