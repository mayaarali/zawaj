import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/helper/api_error_handler.dart';
import 'package:zawaj/core/network/network_info.dart';
import 'package:zawaj/features/home/data/models/home_model.dart';
import 'package:zawaj/features/notification/data/data_source/whoLikedMe_datasource.dart';
import 'package:zawaj/features/notification/data/models/notificationModel.dart';

class WhoLikedMeRepositoryImp {
  WhoLikedMeDataSourceImp whoLikedMeDataSourceImp;
  NetworkInfo networkInfo;
  WhoLikedMeRepositoryImp({
    required this.whoLikedMeDataSourceImp,
    required this.networkInfo,
  });

  Future<Either<String, List<HomeModel>>> whoLikedMe() async {
    List<HomeModel> homeModel = [];
    if (await networkInfo.isConnected) {
      try {
        Response response = await whoLikedMeDataSourceImp.whoLikedMe();

        if (response.statusCode == 200) {
          homeModel = [];
          response.data!.forEach((e) {
            homeModel.add(HomeModel.fromJson(e));
          });

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

  Future<Either<String, List<NotificationModel>>> getNotification() async {
    List<NotificationModel> notificationModel = [];
    if (await networkInfo.isConnected) {
      try {
        Response response = await whoLikedMeDataSourceImp.allNotifications();

        if (response.statusCode == 200) {
          notificationModel = [];
          response.data!.forEach((e) {
            notificationModel.add(NotificationModel.fromJson(e));
            print(response);
          });

          return Right(notificationModel);
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
