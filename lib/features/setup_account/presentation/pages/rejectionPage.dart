import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/custom_appbar.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/features/authentication/presentation/pages/login_signup/signup_page.dart';
import 'package:zawaj/features/setup_account/presentation/pages/set_partenal_data.dart';

class YourProfileIsRejected extends StatelessWidget {
  const YourProfileIsRejected({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   bottomNavigationBar:
      // Padding(
      //     padding: const EdgeInsets.all(15.0),
      //     child: CustomButton(
      //       text: 'ابدأ البحث عن شريكك الآن',
      //       onTap: () {
      //         MagicRouter.navigateTo(SetPartnerData(
      //           isUpdated: false,
      //         ));
      //       },
      //     ),
      //   ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomAppBar(
            isHeartTitle: true,
            isBack: false,
          ),
          // Padding(
          //   padding: EdgeInsets.only(left: context.width * 0.3),
          //   child: Image.asset(
          //     ImageManager.congratulations,
          //     height: 350.0,
          //     width: 350.0,
          //   ),
          // ),
          const CustomText(
            text: 'تم رفض طلبك ',
            fontSize: 25,
          ),
          SizedBox(
            height: context.height * 0.015,
          ),
          const CustomText(
            text: ' افحص الميل خاصتك لمعرفة السبب',
            color: Colors.black,
            fontSize: 20,
          ),
          SizedBox(
            height: context.height * 0.4,
          ),
          GestureDetector(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.disconnect();

              await CacheHelper.removeData(key: Strings.token);
              await CacheHelper.removeData(key: Strings.hasSetup);
              await CacheHelper.removeData(key: Strings.hasRequired);
              await CacheHelper.removeAllData();
              MagicRouter.navigateAndPopAll(const SignUpPage());
            },
            child: const CustomText(
              text: 'تغير البريد الالكتروني',
              fontSize: 15,
              textDecoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
