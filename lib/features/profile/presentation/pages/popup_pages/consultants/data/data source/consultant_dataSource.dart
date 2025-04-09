import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/helper/dio_helper.dart';

class ConsultantDatasource {
  @override
  DioHelper apiClientHelper;
  ConsultantDatasource({required this.apiClientHelper});

  Future getConsultant({String? search, int? page}) {
    return apiClientHelper.getData(
        url: EndPoints.getConsultant,
        query: {"Search": search, "PagesLimit": 10, "Page": page});
  }

  Future clickConsultant({required int consultantId}) {
    return apiClientHelper.putData(
        url: EndPoints.clickConsultant, query: {"ConsultantId": consultantId});
  }
}
