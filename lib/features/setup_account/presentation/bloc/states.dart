import 'package:zawaj/features/setup_account/data/models/area_model.dart';
import 'package:zawaj/features/setup_account/data/models/city_model.dart';

import '../../data/models/params_model.dart';

class SetUpStates {}

class InitStates extends SetUpStates {}

class LoadingSetUp extends SetUpStates {}

class SuccessSetUp extends SetUpStates {}

class FailedSetUp extends SetUpStates {
  String message;
  FailedSetUp({required this.message});
}

class LoadingRequiredSetUp extends SetUpStates {}

class SuccessRequiredSetUp extends SetUpStates {}

class FailedRequiredSetUp extends SetUpStates {
  String message;
  FailedRequiredSetUp({required this.message});
}

class MapValueStates extends SetUpStates {}

class SelectDateeState extends SetUpStates {}

class GetParamsSuccess extends SetUpStates {
  List<ParamsModel> paramsList = [];
  GetParamsSuccess(this.paramsList);
}

class GetParamsLoading extends SetUpStates {}

class SetUpImages extends SetUpStates {}

class GetParamsFailed extends SetUpStates {
  String message;
  GetParamsFailed(this.message);
}

class GetCitySuccess extends SetUpStates {
  List<CityModel> cityList = [];
  GetCitySuccess(this.cityList);
}

class GetCityLoading extends SetUpStates {}

class GetCityFailed extends SetUpStates {
  String message;
  GetCityFailed(this.message);
}

class GetAreaSuccess extends SetUpStates {
  List<AreaModel> areaList = [];
  GetAreaSuccess(this.areaList);
}

class GetAreaLoading extends SetUpStates {}

class GetAreaFailed extends SetUpStates {
  String message;
  GetAreaFailed(this.message);
}

class LoadingUpdatePartner extends SetUpStates {}

class SuccessUpdatePartner extends SetUpStates {}

class FailedUpdatePartner extends SetUpStates {
  String message;
  FailedUpdatePartner({required this.message});
}
