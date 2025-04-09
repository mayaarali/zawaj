import '../../../../core/constants/end_points.dart';
import '../../../../core/helper/dio_helper.dart';

class ProfileDataSourceImp {
  @override
  DioHelper apiClientHelper;
  ProfileDataSourceImp({required this.apiClientHelper});

  Future getProfile() {
    return apiClientHelper
        .getData(url: EndPoints.profile_data, query: {"lang": "ar"});
  }

  Future getProfilePartner() {
    return apiClientHelper
        .getData(url: EndPoints.profile_partner, query: {"lang": "ar"});
  }

  Future deleteProfile() {
    return apiClientHelper.deleteData(
      url: EndPoints.deleteAccount,
    );
  }
}



























    /*required String gender,
    required String searchGender,
    required String name,
    required String birthYear,
    required String cityId,
    required String areaId,
    required String maritalStatus,
    required String minAge,
    required String maxAge,
    required String height,
    required String weight,
    required String isSmoking,*/