import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/helper/api_error_handler.dart';
import 'package:zawaj/core/network/network_info.dart';
import 'package:zawaj/features/profile/presentation/pages/verification/data/verify_data_source/veify_data_source.dart';

class VerifyRepositortyImp {
  VerifyDataSourceImp verifyDataSourceImp;
  NetworkInfo networkInfo;
  VerifyRepositortyImp({
    required this.verifyDataSourceImp,
    required this.networkInfo,
  });
  Future<Either<String, String>> verification({
    required String image1,
    required String image2,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        Response response = await verifyDataSourceImp.verification(
          image1: image1,
          image2: image2,
        );

        if (response.statusCode == 200) {
          return const Right("Verification Success");
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
