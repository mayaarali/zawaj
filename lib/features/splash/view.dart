import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/extensions/colored_print.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/logo_image.dart';
import 'package:zawaj/features/authentication/presentation/pages/login_signup/login_page.dart';
import 'package:zawaj/features/authentication/presentation/pages/login_signup/signup_page.dart';
import 'package:zawaj/features/authentication/presentation/pages/login_signup/signup_success_screen.dart';
import 'package:zawaj/features/authentication/presentation/pages/otp/enter_name_phone_Screen.dart';
import 'package:zawaj/features/dashboard/view.dart';
import 'package:zawaj/features/payment/presentation/pages/payment_possibilities.dart';
import 'package:zawaj/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:zawaj/features/profile/presentation/pages/verification/presentation/verifing_request_sent_screen.dart';
import 'package:zawaj/features/setup_account/presentation/pages/gender_screen.dart';
import 'package:zawaj/features/setup_account/presentation/pages/rejectionPage.dart';
import 'package:zawaj/features/setup_account/presentation/pages/your_profile_is_complete.dart';
import '../../core/constants/strings.dart';
import '../../core/helper/cache_helper.dart';
import '../../core/router/routes.dart';
import '../onBoarding/view.dart';
import 'package:flutter/services.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    ProfileBloc.get(context).getMyProfile();

    String? token = CacheHelper.getData(key: Strings.token);
    String? verificationState =
        CacheHelper.getData(key: Strings.verificationState);
    bool isFirst = CacheHelper.getData(key: Strings.isFirst) ?? true;
    bool hasSetup = CacheHelper.getData(key: Strings.hasSetup) ?? false;
    bool hasRequired = CacheHelper.getData(key: Strings.hasRequired) ?? false;
    bool emailConfirmed =
        CacheHelper.getData(key: Strings.emailConfirmed) ?? false;
    bool phoneConfirmed =
        CacheHelper.getData(key: Strings.phoneConfirmed) ?? false;
    bool isSubscribed = CacheHelper.getData(key: Strings.isSubscribed) ?? false;
    context.printGreen('isFirst=================>$isFirst');
    context.printGreen('hasSetup=================>$hasSetup');
    context.printGreen('hasRequired=================>$hasRequired');
    context.printGreen('token=================>$token');
    context.printGreen('emailConfirmed=================>$emailConfirmed');
    context.printGreen('phoneConfirmed=================>$phoneConfirmed');
    context.printGreen('verificationState=================>$verificationState');
    Future.delayed(const Duration(seconds: 3), () {
      // MagicRouter.navigateAndReplacement(const LoginPage());

      isFirst == true && hasSetup == false
          ? MagicRouter.navigateAndReplacement(const OnBoarding())
          : token == null
              ? MagicRouter.navigateAndReplacement(const LoginPage())
              : emailConfirmed == false
                  ? MagicRouter.navigateAndReplacement(const SignUpPage())
                  : phoneConfirmed == false &&
                          isSubscribed == false &&
                          hasSetup == false &&
                          verificationState == 'Not Verified'
                      ? MagicRouter.navigateAndReplacement(
                          const EnterPhoneAndName())
                      : hasRequired && isSubscribed == true
                          ? MagicRouter.navigateAndReplacement(
                              const DashBoardScreen(
                              initialIndex: 2,
                            ))
                          : phoneConfirmed == true &&
                                      verificationState == 'Not Verified' ||
                                  phoneConfirmed == true &&
                                      verificationState == null
                              ? MagicRouter.navigateAndReplacement(
                                  const SignupSuccess())
                              : verificationState == 'Rejected'
                                  ? MagicRouter.navigateAndReplacement(
                                      const YourProfileIsRejected())
                                  : hasSetup == false &&
                                          verificationState == 'Pending' &&
                                          phoneConfirmed == true
                                      ? MagicRouter.navigateAndReplacement(
                                          const GenderScreen())
                                      : hasSetup == true &&
                                              verificationState == 'Pending' &&
                                              isSubscribed == true
                                          ? MagicRouter.navigateAndReplacement(
                                              const VerificationRequestSent())
                                          : hasSetup == true &&
                                                  verificationState ==
                                                      'Accepted' &&
                                                  isSubscribed == true
                                              ? MagicRouter.navigateAndReplacement(
                                                  const YourProfileIsComplete())
                                              : hasSetup == true &&
                                                      verificationState ==
                                                          'Cancelled'
                                                  ? MagicRouter
                                                      .navigateAndReplacement(
                                                          const SignUpPage())
                                                  : isSubscribed == false &&
                                                          hasSetup == true &&
                                                          (verificationState ==
                                                                  'Pending' ||
                                                              verificationState ==
                                                                  'Accepted')
                                                      ? MagicRouter
                                                          .navigateAndReplacement(
                                                              const PayementPossibility(
                                                          isFromProfileScreen:
                                                              false,
                                                        ))
                                                      : MagicRouter
                                                          .navigateAndReplacement(
                                                              const GenderScreen());

      //   MagicRouter.navigateAndReplacement(const DashBoardScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
      child: CustomScaffold(
          child: Blur(
        blur: 20,
        blurColor: Colors.transparent,
        colorOpacity: 0,
        overlay: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(50),
              child: LogoImage(),
            )
          ],
        ),
        child: Container(
          height: context.height,
          width: context.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            // stops: [0.1, 0.2, 0.3, 0.4],
            colors: [
              ColorManager.splashTopColor.withOpacity(0.7),
              ColorManager.fadePinkColor.withOpacity(0.5),
              ColorManager.fadePinkColor,
              ColorManager.splashBottomColor.withOpacity(0.02),
            ],
          )),
          //  child:
        ),
      )),
    );
  }
}
