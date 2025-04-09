import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/helper/api_error_handler.dart';
import 'package:zawaj/core/network/network_info.dart';
import 'package:zawaj/features/favorites/data/data_source/favorites_datasource.dart';
import 'package:zawaj/features/home/data/models/home_model.dart';

class LikedPartnersRepositoryImp {
  LikedPartnersDataSourceImp likedPartnersDataSourceImp;
  NetworkInfo networkInfo;

  LikedPartnersRepositoryImp({
    required this.likedPartnersDataSourceImp,
    required this.networkInfo,
  });

  Future<Either<String, List<HomeModel>>> likedPartners(
      {int page = 1, int pageLimit = 10}) async {
    List<HomeModel> homeModel = [];
    if (await networkInfo.isConnected) {
      try {
        Response response = await likedPartnersDataSourceImp.likedPartners(
            page: page, pageLimit: pageLimit);

        if (response.statusCode == 200) {
          homeModel = [];
          response.data!.forEach((e) {
            homeModel.add(HomeModel.fromJson(e));
          });
          log("homeModel.length.toString()");
          log(homeModel.length.toString());
          return Right(homeModel);
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
