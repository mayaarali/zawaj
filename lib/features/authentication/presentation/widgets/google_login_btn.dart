import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/loading_circle.dart';
import 'package:zawaj/core/widgets/toast.dart';
import 'package:zawaj/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:zawaj/features/authentication/presentation/bloc/auth_event.dart';
import 'package:zawaj/features/authentication/presentation/bloc/auth_states.dart';
import 'package:zawaj/features/authentication/presentation/pages/login_signup/signup_success_screen.dart';
import 'package:zawaj/features/authentication/presentation/pages/otp/email_verify_otp.dart';
import 'package:zawaj/features/authentication/presentation/pages/otp/enter_name_phone_Screen.dart';
import 'package:zawaj/features/dashboard/view.dart';
import 'package:zawaj/features/payment/presentation/pages/payment_possibilities.dart';
import 'package:zawaj/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:zawaj/features/profile/presentation/pages/verification/presentation/verifing_request_sent_screen.dart';
import 'package:zawaj/features/setup_account/presentation/pages/gender_screen.dart';
import 'package:zawaj/features/setup_account/presentation/pages/rejectionPage.dart';
import 'package:zawaj/features/setup_account/presentation/pages/set_partenal_data.dart';

import '../../../../core/constants/dimensions.dart';
import '../../../../core/constants/image_manager.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/widgets/custom_button.dart';

class GoogleLogin extends StatelessWidget {
  const GoogleLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.buttonRadius)),
        child: BlocConsumer<AuthBloc, AuthStates>(
          listener: (BuildContext context, AuthStates state) async {
            if (state is AuthSuccess) {
              bool hasSetup =
                  await CacheHelper.getData(key: Strings.hasSetup) ?? false;
              bool hasRequired =
                  await CacheHelper.getData(key: Strings.hasRequired) ?? false;
              bool phoneConfirmed =
                  await CacheHelper.getData(key: Strings.phoneConfirmed) ??
                      false;
              String? verificationState =
                  CacheHelper.getData(key: Strings.verificationState);
              bool isSubscribed =
                  CacheHelper.getData(key: Strings.isSubscribed) ?? false;
              bool emailConfirmed = true;
              //    bool phoneConfirmed = true;
              log('looooogin setup========>$hasSetup');
              log('looooogin Required========>$hasRequired');
              log('emailConfirmed=================>$emailConfirmed');
              log('phoneConfirmed=================>$phoneConfirmed');
              log('verificationState=================>$verificationState');

              if (hasRequired && verificationState == 'Rejected') {
                MagicRouter.navigateAndPopAll(const YourProfileIsRejected());
              } else if (hasRequired &&
                  verificationState == 'Accepted' &&
                  isSubscribed == true) {
                MagicRouter.navigateAndPopAll(const DashBoardScreen(
                  initialIndex: 2,
                ));
              } else if (hasSetup &&
                  verificationState == 'Accepted' &&
                  isSubscribed == true) {
                MagicRouter.navigateAndReplacement(SetPartnerData(
                  isUpdated: false,
                ));
              } else if (verificationState == 'Rejected') {
                MagicRouter.navigateAndReplacement(
                    const YourProfileIsRejected());
              } else if (hasSetup == false &&
                      verificationState == 'Not Verified' &&
                      phoneConfirmed == false ||
                  hasSetup == false &&
                      verificationState == null &&
                      phoneConfirmed == false) {
                MagicRouter.navigateAndReplacement(const EnterPhoneAndName());

                //  MagicRouter.navigateAndReplacement(const SignupSuccess());
              } else if (verificationState == 'Pending' &&
                      hasSetup == true &&
                      isSubscribed == true ||
                  hasSetup == true &&
                      isSubscribed == true &&
                      verificationState == 'Cancelled') {
                MagicRouter.navigateAndReplacement(
                    const VerificationRequestSent());
              } else if ((verificationState == 'Not Verified' &&
                      phoneConfirmed == false) ||
                  (verificationState == null && phoneConfirmed == false)) {
                MagicRouter.navigateAndReplacement(const EnterPhoneAndName());

                //  MagicRouter.navigateAndReplacement(const SignupSuccess());
              } else if ((isSubscribed == false &&
                  hasSetup == true &&
                  (verificationState == 'Pending' ||
                      verificationState == 'Accepted'))) {
                MagicRouter.navigateAndReplacement(const PayementPossibility(
                  isFromProfileScreen: false,
                ));
              } else if (isSubscribed == false &&
                  phoneConfirmed == true &&
                  hasSetup == false) {
                MagicRouter.navigateAndReplacement(const SignupSuccess());
              } else {
                MagicRouter.navigateAndReplacement(const GenderScreen());
              }
            } else if (state is AuthFailed) {
              showToast(msg: state.message
                  //"فشل! حاول مرة اخرى"
                  );
            } else if (state is GoogleLoginFail) {
              // showToast(
              //     msg: "Failed! Please Try Again",
              //     gravity: ToastGravity.BOTTOM,
              //     background: ColorManager.primaryColor,
              //     textColor: ColorManager.secondaryPinkColor);
            }
          },
          builder: (BuildContext context, AuthStates state) =>
              state is LoadingAuth
                  ? const SizedBox()
                  : CustomButton(
                      onTap: () {
                        AuthBloc.get(context).add(SocialLoginEvent());
                        //  AuthBloc.get(context).signInWithGoogle();
                      },
                      text: Strings.google_sign_in,
                      color: Colors.white,
                      iconWidget: Image.asset(ImageManager.google),
                      txtColor: ColorManager.primaryColor,
                      height: Dimensions(context: context).textFieldHeight,
                    ),
        ));
  }
}
