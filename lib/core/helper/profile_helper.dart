import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/features/payment/presentation/pages/payment_possibilities.dart';
import 'package:zawaj/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/pages/rejectionPage.dart'; // For date formatting if needed

class ProfileHelper {
  static void checkVerificationAndSubscription(BuildContext context) {
    final verificationState =
        ProfileBloc.get(context).profileData?.verificationStatus.toString();

    if (verificationState == 'Rejected') {
      log('You are rejected');

      CacheHelper.setData(key: Strings.verificationState, value: 'Rejected');
      MagicRouter.navigateAndPopAll(const YourProfileIsRejected());
      return;
    }

    final expiredDateSubscribe =
        ProfileBloc.get(context).profileData?.expiredDateSubscribe.toString() ??
            '';

    final today = _getTodayDate();
    log('expiredDateSubscribe => $expiredDateSubscribe');

    final expiredDate = DateFormat('M/d/yyyy').parse(expiredDateSubscribe);

    if (expiredDate.isBefore(today) || expiredDate.isAtSameMomentAs(today)) {
      CacheHelper.setData(key: Strings.isSubscribed, value: false);
      MagicRouter.navigateAndPopAll(const PayementPossibility(
        isFromProfileScreen: false,
      ));
      log('expiredDateSubscribe => $expiredDateSubscribe');
      log('isSubscribed => ${CacheHelper.getData(key: Strings.isSubscribed)}');
      return;
    }
  }

  static DateTime _getTodayDate() {
    return DateTime.now();
  }
}
