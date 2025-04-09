import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/extensions/bottom_sheet.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/custom_appbar.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:zawaj/features/authentication/presentation/bloc/auth_event.dart';
import 'package:zawaj/features/authentication/presentation/pages/login_signup/login_page.dart';
import 'package:zawaj/features/authentication/presentation/pages/otp/email_verify_otp.dart';
import 'package:zawaj/features/setup_account/presentation/pages/gender_screen.dart';
import '../../../../../core/validator/validator.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/loading_circle.dart';
import '../../bloc/auth_states.dart';
import '../../widgets/facebook_login_btn.dart';
import '../../widgets/google_login_btn.dart';
part 'units/signup_buttons.dart';
part 'units/signup_forms.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  static final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
              text: Strings.welcome,
              color: ColorManager.greyTextColor,
              //   fontSize: Dimensions.largeFont,
            ),
            const SizedBox(
              height: 20,
            ),
            const CustomText(
              fontWeight: FontWeight.bold,
              text: Strings.create_account,
              // fontSize: Dimensions.smallFont,
            ),
            const SocialMediaSignupButtons(),
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
            Form(key: SignUpPage.signupFormKey, child: const SignUpForms()),
            BlocConsumer<AuthBloc, AuthStates>(
              listener: (BuildContext context, AuthStates state) {
                if (state is RegisterSuccess) {
                  MagicRouter.navigateAndReplacement(const EmailVerify());
                }
              },
              builder: (BuildContext context, AuthStates state) => state
                      is LoadingAuth
                  ? const LoadingCircle()
                  : CustomButton(
                      onTap: () {
                        if (SignUpPage.signupFormKey.currentState!.validate()) {
                          String? deviceId =
                              CacheHelper.getData(key: Strings.DEVICEID);
                          if (deviceId == null ||
                              deviceId == '' ||
                              deviceId == 'fake') {
                            initNotification();
                          }
                          AuthBloc.get(context).add(RegisterEvent());
                        }
                      },
                      text: Strings.register),
            ),
            const SizedBox(
              height: 10,
            ),
            const SignUpButtons()
          ],
        ),
      ),
    ));
  }
}

initNotification() async {
  try {
    print('//////////////PRINT IN LOGIN/////////////////////////');
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
    log('device id in observer:' + CacheHelper.getData(key: Strings.DEVICEID));
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
