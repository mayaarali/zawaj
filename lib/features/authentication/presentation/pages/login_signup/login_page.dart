import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/custom_appbar.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:zawaj/features/authentication/presentation/bloc/auth_states.dart';
import 'package:zawaj/features/authentication/presentation/pages/login_signup/signup_page.dart';
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
import 'package:zawaj/features/setup_account/presentation/pages/your_profile_is_complete.dart';
import '../../../../../core/validator/validator.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/loading_circle.dart';
import '../../bloc/auth_event.dart';
import '../../widgets/facebook_login_btn.dart';
import '../../widgets/google_login_btn.dart';
import '../reset_password/reset_password.dart';
part 'units/login_buttons.dart';
part 'units/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    initNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.defaultPadding),
        child: Column(
          children: [
            const CustomAppBar(
              isLogoTitle: true,
              isBack: false,
            ),
            const SizedBox(
              height: 15,
            ),
            const CustomText(
              text: Strings.welcome_back,
              fontSize: Dimensions.largeFont,
            ),
            const SizedBox(
              height: 15,
            ),
            const CustomText(
              text: Strings.login_to_reach_account,
              fontSize: Dimensions.smallFont,
            ),
            Form(key: LoginPage.loginFormKey, child: const LoginForm()),
            InkWell(
              onTap: () {
                MagicRouter.navigateTo(const ResetPasswordPage());
              },
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: Strings.forget_password,
                    fontSize: Dimensions.smallFont,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            BlocConsumer<AuthBloc, AuthStates>(
              listener: (BuildContext context, AuthStates state) async {
                if (state is AuthSuccess) {
                  bool hasSetup =
                      await CacheHelper.getData(key: Strings.hasSetup) ?? false;
                  bool hasRequired =
                      await CacheHelper.getData(key: Strings.hasRequired) ??
                          false;
                  String? verificationState =
                      CacheHelper.getData(key: Strings.verificationState);
                  bool emailConfirmed =
                      CacheHelper.getData(key: Strings.emailConfirmed) ?? false;
                  bool phoneConfirmed =
                      CacheHelper.getData(key: Strings.phoneConfirmed) ?? false;
                  bool isSubscribed =
                      CacheHelper.getData(key: Strings.isSubscribed) ?? false;
                  log('looooogin setup========>$hasSetup');
                  log('looooogin Required========>$hasRequired');
                  log('emailConfirmed=================>$emailConfirmed');
                  log('phoneConfirmed=================>$phoneConfirmed');
                  log('verificationState=================>$verificationState');
                  if (hasRequired) {
                    MagicRouter.navigateAndReplacement(const DashBoardScreen(
                      initialIndex: 2,
                    ));
                  } else if (verificationState == 'Rejected') {
                    MagicRouter.navigateAndReplacement(
                        const YourProfileIsRejected());
                  } else if (hasSetup == false &&
                      verificationState == 'Pending') {
                    MagicRouter.navigateAndReplacement(const GenderScreen());
                  } else if (hasSetup && verificationState == 'Accepted') {
                    MagicRouter.navigateAndReplacement(
                        const YourProfileIsComplete());
                  } else if (hasSetup == true &&
                          verificationState == 'Pending' &&
                          isSubscribed == true ||
                      hasSetup == true && verificationState == 'Cancelled') {
                    MagicRouter.navigateAndReplacement(
                        const VerificationRequestSent());
                  } else if (verificationState == 'Not Verified' ||
                      verificationState == null) {
                    MagicRouter.navigateAndReplacement(const SignupSuccess());
                  } else if (phoneConfirmed == false) {
                    MagicRouter.navigateAndReplacement(
                        const EnterPhoneAndName());
                  } else if (emailConfirmed == false) {
                    MagicRouter.navigateAndReplacement(const SignUpPage());
                  } else if (isSubscribed == false &&
                      hasSetup == true &&
                      verificationState == 'Pending') {
                    MagicRouter.navigateAndReplacement(
                        const PayementPossibility(
                      isFromProfileScreen: false,
                    ));
                  } else {
                    MagicRouter.navigateAndReplacement(const GenderScreen());
                  }
                }
              },
              builder: (BuildContext context, AuthStates state) => state
                      is LoadingAuth
                  ? const LoadingCircle()
                  : CustomButton(
                      onTap: () async {
                        if (LoginPage.loginFormKey.currentState!.validate()) {
                          String? deviceId =
                              CacheHelper.getData(key: Strings.DEVICEID);
                          if (deviceId == null ||
                              deviceId == '' ||
                              deviceId == 'fake') {
                            initNotification();
                          }

                          AuthBloc.get(context).add(LoginEvent(
                              email: AuthBloc.get(context).emailController.text,
                              pass: AuthBloc.get(context)
                                  .passwordController
                                  .text));
                        }
                      },
                      text: Strings.next),
            ),
            const SizedBox(
              height: 30,
            ),
            const Row(
              children: [
                Expanded(
                    child: Divider(
                  color: ColorManager.secondaryPinkColor,
                )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: CustomText(text: Strings.or),
                ),
                Expanded(
                    child: Divider(
                  color: ColorManager.secondaryPinkColor,
                )),
              ],
            ),
            const LoginButtons(),
            Column(
              children: [
                const CustomText(
                  text: Strings.have_no_account,
                  fontSize: Dimensions.normalFont,
                ),
                const SizedBox(
                  height: 5,
                ),
                InkWell(
                    onTap: () {
                      MagicRouter.navigateAndReplacement(const SignUpPage());
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: Strings.register,
                          fontSize: Dimensions.normalFont,
                          textDecoration: TextDecoration.underline,
                        ),
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  initNotification() async {
    try {
      print('///PRINT IN LOGIN///');

      OneSignal.initialize("30b87e9d-8b0d-4e52-8764-850cb0f0391f");
      await OneSignal.Notifications.requestPermission(true);
      //OneSignal.User.getOnesignalId()

      String? id2 = OneSignal.User.pushSubscription.token;
      String? id = OneSignal.User.pushSubscription.id;
      String? id3 = await OneSignal.User.getOnesignalId();

      print('id333333 is ${id3}');
      print('id is ${id}');
      print('id222222 is ${id2}');

      CacheHelper.setData(key: Strings.DEVICEID, value: id ?? 'fake');

      // String? id2;
      id2 = OneSignal.User.pushSubscription.id;
    } catch (e) {
      print('kkkkkkkkkkkkkkkkkkkkkkkkk$e');
    }

    OneSignal.User.pushSubscription.addObserver((state) {
      print("ussssserId22");

      ///print(id2);
      print("ussssserId");
      print(OneSignal.User.pushSubscription.optedIn);
      print(OneSignal.User.pushSubscription.id);
      print(OneSignal.User.pushSubscription.token);
      print(state.current.jsonRepresentation());
      CacheHelper.setData(
          key: Strings.DEVICEID,
          value: OneSignal.User.pushSubscription.id ?? 'fake');
      log('device id in observer:' +
          CacheHelper.getData(key: Strings.DEVICEID));
    });
    print("AFTER ABSERVER");
    print(CacheHelper.getData(
      key: Strings.DEVICEID,
    ));

    String? id2 = OneSignal.User.pushSubscription.token;
    String? id = OneSignal.User.pushSubscription.id;
    String? id3 = await OneSignal.User.getOnesignalId();

    print('id333333 is ${id3}');
    print('id is ${id}');
    print('id222222 is ${id2}');
    String? deviceId = await CacheHelper.getData(
      key: Strings.DEVICEID,
    );
    if (deviceId == null || deviceId == '' || deviceId == 'fake') {
      await CacheHelper.setData(
          key: Strings.DEVICEID,
          value: OneSignal.User.pushSubscription.id ?? 'fake');

      log('device id:' + CacheHelper.getData(key: Strings.DEVICEID));
    }
    print("AFTER Condition");
    print(CacheHelper.getData(
      key: Strings.DEVICEID,
    ));
  }
}
