import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/custom_appbar.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/features/authentication/presentation/pages/login_signup/terms_screen.dart';

class SignupSuccess extends StatelessWidget {
  const SignupSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomButton(
            onTap: () {
              MagicRouter.navigateTo(const TermsAndConditionsScreen());
            },
            text: Strings.undersrtand),
      ),
      child: Column(
        children: [
          const CustomAppBar(
            isBack: false,
            isLogoTitle: true,
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                //   mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SvgPicture.asset(
                        ImageManager.heartLogo,
                        width: 120,
                        height: 80,
                      )),
                  const CustomText(
                    text: Strings.registerSuccess,
                    fontSize: Dimensions.largeFont,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const CustomText(
                    text: Strings.registerextraSteps,
                    color: ColorManager.greyTextColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
