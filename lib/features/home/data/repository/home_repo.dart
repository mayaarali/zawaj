import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/helper/api_error_handler.dart';
import 'package:zawaj/core/network/network_info.dart';
import 'package:zawaj/features/home/data/data_source/home_datascource.dart';
import 'package:zawaj/features/home/data/models/home_model.dart';

class HomeRepositoryImp {
  HomeDataSourceImp homeDataSourceImp;
  NetworkInfo networkInfo;
  HomeRepositoryImp({
    required this.homeDataSourceImp,
    required this.networkInfo,
  });

  Future<Either<String, List<HomeModel>>> getPartnerData(
      {int page = 1, int pageLimit = 10}) async {
    List<HomeModel> homeList = [];
    if (await networkInfo.isConnected) {
      try {
        Response response = await homeDataSourceImp.getPartnerData(
            page: page, pageLimit: pageLimit);
        if (response.statusCode == 200) {
          log('200 home data');
          homeList = [];
          response.data!.forEach((e) {
            homeList.add(HomeModel.fromJson(e));
          });

          return Right(homeList);
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

  Future<Either<String, String>> isLikedPost({required String userId}) async {
    if (await networkInfo.isConnected) {
      try {
        Response likedresponse =
            await homeDataSourceImp.isPostLiked(userId: userId);
        if (likedresponse.statusCode == 200) {
          return Right(likedresponse.data["message"]);
        } else {
          return Left(ApiExceptionHandler.getMessage(likedresponse));
        }
      } on DioException catch (error) {
        return Left(ApiExceptionHandler.getMessage(error));
      }
    } else {
      return const Left(Strings.nointernet);
    }
  }

  Future<Either<String, String>> isDisLikedPost(
      {required String userId}) async {
    if (await networkInfo.isConnected) {
      try {
        Response disLikedresponse =
            await homeDataSourceImp.isPostDisliked(userId: userId);
        if (disLikedresponse.statusCode == 200) {
          return Right(disLikedresponse.data["message"]);
        } else {
          return Left(ApiExceptionHandler.getMessage(disLikedresponse));
        }
      } on DioException catch (error) {
        return Left(ApiExceptionHandler.getMessage(error));
      }
    } else {
      return const Left(Strings.nointernet);
    }
  }

  Future<Either<String, String>> removeUser({required String userId}) async {
    if (await networkInfo.isConnected) {
      try {
        Response removeResponse =
            await homeDataSourceImp.removeUser(userId: userId);
        if (removeResponse.statusCode == 200) {
          return Right(removeResponse.data["message"]);
        } else {
          return Left(ApiExceptionHandler.getMessage(removeResponse));
        }
      } on DioException catch (error) {
        return Left(ApiExceptionHandler.getMessage(error));
      }
    } else {
      return const Left(Strings.nointernet);
    }
  }
}
