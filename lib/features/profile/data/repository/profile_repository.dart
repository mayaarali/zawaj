import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/features/profile/data/models/profile_model.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/helper/api_error_handler.dart';
import '../../../../core/network/network_info.dart';
import '../data_source/profile_datasource.dart';
import '../models/partner_model.dart';

class ProfileRepositoryImp {
  ProfileDataSourceImp profileDataSourceImp;
  NetworkInfo networkInfo;
  ProfileRepositoryImp(
      {required this.profileDataSourceImp, required this.networkInfo});

  Future<Either<String, ProfileData>> getProfile() async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await profileDataSourceImp.getProfile();
        log(response.data.toString());
        if (response.statusCode == 200) {
          ProfileData profileData = ProfileData.fromJson(response.data);
          CacheHelper.setData(
              key: Strings.verificationState,
              value: response.data['verificationStatus']);

          return Right(profileData);
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

  Future<Either<String, PartnerData>> getPartnerProfile() async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await profileDataSourceImp.getProfilePartner();
        if (response.statusCode == 200) {
          PartnerData partnerData = PartnerData.fromJson(response.data);

          return Right(partnerData);
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

  Future<Either<String, String>> deleteProfile() async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await profileDataSourceImp.deleteProfile();
        if (response.statusCode == 200) {
          return const Right(Strings.accountDeleted);
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
