import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/helper/api_error_handler.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/core/network/network_info.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/features/payment/data/dataScource/payment_datascource.dart';
import 'package:zawaj/features/payment/data/models/payment_model.dart';
import 'package:zawaj/features/profile/presentation/bloc/profile_bloc.dart';

import '../../../dashboard/view.dart';
import '../../../profile/presentation/pages/verification/presentation/verifing_request_sent_screen.dart';

class PaymentRepositoryImp {
  PaymentDataScourceImp paymentDataScourceImp;
  NetworkInfo networkInfo;
  PaymentRepositoryImp(
      {required this.paymentDataScourceImp, required this.networkInfo});
  Future<Either<String, List<PaymentModel>>> getPaymentPlan() async {
    List<PaymentModel> paymentModel = [];
    if (await networkInfo.isConnected) {
      print('iaamm hereee');
      try {
        var response = await paymentDataScourceImp.getPaymentPlans();

        if (response.statusCode == 200) {
          print('20000000');
          paymentModel = [];
          response.data!.forEach((e) {
            paymentModel.add(PaymentModel.fromJson(e));
          });
          print(paymentModel);

          return Right(paymentModel);
        } else {
          return Left(ApiExceptionHandler.getMessage(response));
        }
      } on DioException catch (error) {
        print(error);
        return Left(ApiExceptionHandler.getMessage(error));
      }
    } else {
      return const Left(Strings.nointernet);
    }
  }

  Future<Either<String, List<StandardPaymentValueModel>>>
      getPaymentStandardPlan() async {
    List<StandardPaymentValueModel> standardPaymentModels = [];

    if (await networkInfo.isConnected) {
      try {
        var response = await paymentDataScourceImp.getPaymentStanderedPlan();

        log('Response received: ${response.toString()}');

        if (response.statusCode == 200 && response.data != null) {
          var data = response.data;

          if (data is List) {
            standardPaymentModels = data
                .map((e) => StandardPaymentValueModel.fromJson(
                    e as Map<String, dynamic>))
                .toList();
            return Right(standardPaymentModels);
          } else if (data is Map) {
            standardPaymentModels.add(StandardPaymentValueModel.fromJson(
                data as Map<String, dynamic>));
            return Right(standardPaymentModels);
          } else {
            log('Unexpected data format: ${data.runtimeType}');
            return const Left('Unexpected data format.');
          }
        } else {
          log('Error response: ${response.statusCode}');
          return Left(ApiExceptionHandler.getMessage(response));
        }
      } on DioException catch (error) {
        log('DioException error: ${error.toString()}');
        return Left(ApiExceptionHandler.getMessage(error));
      } catch (e, stackTrace) {
        log('Unexpected error: $e');
        log('Stack trace: $stackTrace');
        return const Left('An unexpected error occurred.');
      }
    } else {
      return const Left(Strings.nointernet);
    }
  }

  Future<Either<String, String>> addPaymentPlan({
    int? plainId,
    int? standardValue,
  }) async {
    if (await networkInfo.isConnected) {
      print('iaamm hereee');
      try {
        var response = await paymentDataScourceImp.postPaymentPlans(
          plainId: plainId,
          standardValue: standardValue,
        );

        log('dattttttta--->${response}');
        if (response.statusCode == 200) {
          print('20000000');
          CacheHelper.setData(key: Strings.url, value: response.data['url']);

          return const Right(Strings.done);
        } else {
          return Left(ApiExceptionHandler.getMessage('فشل '));
        }
      } on DioException catch (error) {
        print(error);
        return Left(ApiExceptionHandler.getMessage(error));
      }
    } else {
      return const Left(Strings.nointernet);
    }
  }

  Future<Either<String, String>> verifyPayment({
    int? plainId,
    int? standardValue,
    required String userId,
    required String url,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        var response = await paymentDataScourceImp.verifyPayment(
          plainId: plainId,
          standardValue: standardValue,
          userId: userId,
          url: url,
        );

        log('VerifyPayment Response: $response');
        await CacheHelper.setData(key: Strings.isSubscribed, value: true);
        if (response.statusCode == 200) {
          return const Right(Strings.done);
        } else {
          return Left(ApiExceptionHandler.getMessage('Failed'));
        }
      } on DioException catch (error) {
        print(error);
        return Left(ApiExceptionHandler.getMessage(error));
      }
    } else {
      return const Left(Strings.nointernet);
    }
  }
}
