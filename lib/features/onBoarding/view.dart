import 'package:flutter/material.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/core/widgets/logo_image.dart';
import 'package:zawaj/features/authentication/presentation/pages/login_signup/login_page.dart';
import 'package:zawaj/features/authentication/presentation/pages/login_signup/signup_page.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  @override
  void initState() {
    CacheHelper.setData(key: Strings.isFirst, value: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        child: Container(
      height: context.height,
      width: context.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage(ImageManager.pink_background),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              ImageManager.onboarding,
              height: context.height * 0.5,
              width: context.width,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: const LogoImage(),
            ),
            const SizedBox(
              height: 20,
            ),
            const CustomText(
              text: Strings.onboarding,
              color: ColorManager.greyTextColor,
              fontWeight: FontWeight.w600,
            ),
            const Spacer(),
            Align(
                alignment: Alignment.bottomCenter,
                child: CustomButton(
                  onTap: () {
                    MagicRouter.navigateTo(const SignUpPage());
                  },
                  text: Strings.continu,
                )),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    ));
  }
}

// Stack(
// children: [
// Container(
// height: context.height,
// width: context.width,
//
//
// ),
// Container(
// height: 120,
// width: 120,
// decoration: BoxDecoration(
//
// color: ColorManager.fadePinkColor.withOpacity(05),
// shape: BoxShape.circle,boxShadow: [
// BoxShadow(color: ColorManager.fadePinkColor,spreadRadius: 50,blurStyle: BlurStyle.outer,offset: Offset(3,0))
// ]),
// )
// ],
// )