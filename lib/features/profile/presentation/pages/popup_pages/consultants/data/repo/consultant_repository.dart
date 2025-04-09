import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/helper/api_error_handler.dart';
import 'package:zawaj/core/network/network_info.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/consultants/data/data%20source/consultant_dataSource.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/consultants/data/models/consultants_model.dart';

class ConsultantRepositoryImp {
  ConsultantDatasource consultantDatasource;
  NetworkInfo networkInfo;
  ConsultantRepositoryImp({
    required this.consultantDatasource,
    required this.networkInfo,
  });

  Future<Either<String, List<ConsultantModel>>> getConsultant(
      {String? search, int? page}) async {
    List<ConsultantModel> consultantList = [];

    if (await networkInfo.isConnected) {
      try {
        Response response = await consultantDatasource.getConsultant(
            search: search!, page: page);
        log('Response data: ${response.data}');

        if (response.statusCode == 200) {
          consultantList = [];

          List<dynamic> data = response.data['result'];
          for (var e in data) {
            consultantList.add(ConsultantModel.fromJson(e));
          }

          return Right(consultantList);
        } else {
          return Left(ApiExceptionHandler.getMessage(response));
        }
      } on DioException catch (error) {
        log('Dio error: ${error.message}');
        return Left(ApiExceptionHandler.getMessage(error));
      }
    } else {
      return const Left(Strings.nointernet);
    }
  }

  Future<Either<String, String>> clickConsultant({
    required int consultantId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await consultantDatasource.clickConsultant(
            consultantId: consultantId);
        print('***************response.data');

        print(response.data);
        if (response.statusCode == 200) {
          return Right(Strings.login_success);
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
