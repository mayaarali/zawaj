import 'dart:developer';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/helper/dio_helper.dart';

class PaymentDataScourceImp {
  DioHelper apiClientHelper;

  PaymentDataScourceImp({required this.apiClientHelper});

  getPaymentPlans() {
    apiClientHelper.getData(url: EndPoints.getPaymentPlans).then((value) {
      print(value);
      print('iaM INNN THHHEEEEENNN');
    });
    return apiClientHelper.getData(url: EndPoints.getPaymentPlans);
  }

  getPaymentStanderedPlan() {
    apiClientHelper
        .getData(url: EndPoints.getStandardPaymentValue)
        .then((value) {
      log(value.toString());
      log('iaM INNN THHHEEEEENNN getStandardPaymentValue');
    });
    return apiClientHelper.getData(url: EndPoints.getStandardPaymentValue);
  }

  postPaymentPlans({
    int? plainId,
    int? standardValue,
  }) {
    return apiClientHelper.postData(
      url: EndPoints.postPaymentPlans,
      query: {
        if (plainId != null) "PlainId": plainId,
        if (standardValue != null) "StandardValue": standardValue,
      },
    );
  }

  verifyPayment({
    int? plainId,
    int? standardValue,
    required String userId,
    required String url,
  }) {
    return apiClientHelper.postData(
      url: EndPoints.verifyPayment,
      query: {
        if (plainId != null) "PlainId": plainId,
        if (standardValue != null) "StandardValue": standardValue,
        "UserId": userId,
        "Url": url,
      },
    );
  }
}
