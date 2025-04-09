import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zawaj/features/setup_account/data/models/area_model.dart';
import 'package:zawaj/features/setup_account/data/models/city_model.dart';
import 'package:zawaj/features/setup_account/data/models/params_model.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/helper/api_error_handler.dart';
import '../../../../core/helper/cache_helper.dart';
import '../../../../core/network/network_info.dart';
import '../data_source/setup_datasource.dart';
import '../models/setup_required_body.dart';
import '../models/setup_response.dart';

class SetUpRepositoryImp {
  SetupDataSourceImp setupDataSourceImp;
  NetworkInfo networkInfo;
  SetUpRepositoryImp(
      {required this.setupDataSourceImp, required this.networkInfo});
  Future<Either<String, List<ParamsModel>>> getParams() async {
    List<ParamsModel> paramsList = [];
    if (await networkInfo.isConnected) {
      try {
        Response response = await setupDataSourceImp.getParams();
        // RegisterModel registerResponse = RegisterModel.fromJson(response.data);
        if (response.statusCode == 200) {
          paramsList = [];
          response.data!.forEach((e) {
            paramsList.add(ParamsModel.fromJson(e));
          });
          //CacheHelper.setUserData(registerResponse.user!);

          return Right(paramsList);
        } else {
          return Left(ApiExceptionHandler.getMessage(response));
        }
      } on DioException catch (error) {
        return Left(ApiExceptionHandler.getMessage(error));
      }
    } else {
      return const Left(Strings.nointernet);
    }
  }

  Future<Either<String, List<CityModel>>> getCity() async {
    List<CityModel> cityList = [];
    if (await networkInfo.isConnected) {
      try {
        Response response = await setupDataSourceImp.getCity();
        if (response.statusCode == 200) {
          cityList = [];
          response.data!.forEach((e) {
            cityList.add(CityModel.fromJson(e));
          });

          return Right(cityList);
        } else {
          return Left(ApiExceptionHandler.getMessage(response));
        }
      } on DioException catch (error) {
        return Left(ApiExceptionHandler.getMessage(error));
      }
    } else {
      return const Left(Strings.nointernet);
    }
  }

  Future<Either<String, List<AreaModel>>> getArea({required int cityId}) async {
    List<AreaModel> areaList = [];
    if (await networkInfo.isConnected) {
      try {
        Response response = await setupDataSourceImp.getArea(cityId: cityId);
        if (response.statusCode == 200) {
          areaList = [];
          response.data!.forEach((e) {
            areaList.add(AreaModel.fromJson(e));
          });

          return Right(areaList);
        } else {
          return Left(ApiExceptionHandler.getMessage(response));
        }
      } on DioException catch (error) {
        return Left(ApiExceptionHandler.getMessage(error));
      }
    } else {
      return const Left(Strings.nointernet);
    }
  }

  Future<Either<String, SetupResponse>> postSetup(
      Map<String, dynamic> setupmap) async {
    if (await networkInfo.isConnected) {
      try {
        Response response =
            await setupDataSourceImp.postSetup(setUpMap: setupmap);
        if (response.statusCode == 200) {
          CacheHelper.setData(key: Strings.hasSetup, value: true);
          SetupResponse setupResponse = SetupResponse.fromJson(response.data);
          print(setupmap);
          return Right(setupResponse);
        } else {
          return Left(ApiExceptionHandler.getMessage(response));
        }
      } on DioException catch (error) {
        return Left(ApiExceptionHandler.getMessage(error));
      }
    } else {
      return const Left(Strings.nointernet);
    }
  }

  Future<Either<String, SetupResponse>> updateSetup(
      Map<String, dynamic> setupmap) async {
    if (await networkInfo.isConnected) {
      try {
        Response response =
            await setupDataSourceImp.updateSetup(setUpMap: setupmap);
        if (response.statusCode == 200) {
          CacheHelper.setData(key: Strings.hasSetup, value: true);
          SetupResponse setupResponse = SetupResponse.fromJson(response.data);
          print(setupmap);
          return Right(setupResponse);
        } else {
          return Left(ApiExceptionHandler.getMessage(response));
        }
      } on DioException catch (error) {
        return Left(ApiExceptionHandler.getMessage(error));
      }
    } else {
      return const Left(Strings.nointernet);
    }
  }

  Future<Either<String, SetupResponse>> updatePartner(
      SetupRequiredBody setupRequiredBody) async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await setupDataSourceImp.updatePartner(
            setupRequiredBody: setupRequiredBody);
        if (response.statusCode == 200) {
          SetupResponse setupResponse = SetupResponse.fromJson(response.data);
          return Right(setupResponse);
        } else {
          return Left(ApiExceptionHandler.getMessage(response));
        }
      } on DioException catch (error) {
        return Left(ApiExceptionHandler.getMessage(error));
      }
    } else {
      return const Left(Strings.nointernet);
    }
  }

  Future<Either<String, SetupResponse>> postRequired(
      SetupRequiredBody setupRequiredBody) async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await setupDataSourceImp.postRequired(
            setupRequiredBody: setupRequiredBody);
        if (response.statusCode == 200) {
          CacheHelper.setData(key: Strings.hasRequired, value: true);
          SetupResponse setupResponse = SetupResponse.fromJson(response.data);
          print(setupRequiredBody);
          return Right(setupResponse);
        } else {
          return Left(ApiExceptionHandler.getMessage(response));
        }
      } on DioException catch (error) {
        return Left(ApiExceptionHandler.getMessage(error));
      }
    } else {
      return const Left(Strings.nointernet);
    }
  }
}

/*

 response.data!.forEach((e) {
          setup[e['key']] = e['value'];
        });
  */
