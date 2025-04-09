import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/constants/end_points.dart';
import '../../../../core/helper/dio_helper.dart';
import '../models/setup_required_body.dart';

class SetupDataSourceImp {
  @override
  DioHelper apiClientHelper;
  SetupDataSourceImp({required this.apiClientHelper});

  Future getParams() {
    return apiClientHelper
        .getData(url: EndPoints.setup_params, query: {"lang": "ar"});
  }

  Future getCity() {
    return apiClientHelper.getData(
      url: EndPoints.get_City,
    );
  }

  Future getArea({required int cityId}) {
    return apiClientHelper
        .getData(url: EndPoints.get_Area, query: {"CityId": cityId});
  }

  Future postSetup({
    required Map<String, dynamic> setUpMap,
  }) {
    FormData map = FormData.fromMap(setUpMap);
    return apiClientHelper.postData(
      data: map,
      url: EndPoints.post_Setup,
    );
  }

  Future updateSetup({
    required Map<String, dynamic> setUpMap,
  }) {
    FormData map = FormData.fromMap(setUpMap);
    return apiClientHelper.putData(
      data: map,
      url: EndPoints.update_Setup,
    );
  }

  Future postRequired({
    required SetupRequiredBody setupRequiredBody,
  }) {
    FormData map = FormData.fromMap(setupRequiredBody.toJson());
    return apiClientHelper.postData(
      data: map,
      url: EndPoints.post_required,
    );
  }

  Future updatePartner({
    required SetupRequiredBody setupRequiredBody,
  }) {
    FormData map = FormData.fromMap(setupRequiredBody.toJson());
    String currentTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    return apiClientHelper.putData(
        url: EndPoints.updatePartnerDetails,
        data: map,
        query: {"lang": "ar", "modificationTime": currentTime});
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
