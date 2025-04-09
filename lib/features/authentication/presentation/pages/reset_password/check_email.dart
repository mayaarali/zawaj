import 'package:flutter/material.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/custom_appbar.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/features/authentication/presentation/pages/new_password/reenter_password.dart';
import 'package:zawaj/features/authentication/presentation/pages/otp/otp_page.dart';

import '../../../../../core/widgets/custom_text.dart';

class CheckEmailPage extends StatelessWidget {
  const CheckEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        isFullScreen: true,
        child: SizedBox(
          height: context.height,
          width: context.width,
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.defaultPadding),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CustomAppBar(
                    isLogoTitle: true,
                  ),
                  SizedBox(
                    height: context.height * 0.5,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: Strings.email_sent,
                            align: TextAlign.center,
                            fontSize: Dimensions.mediumFont,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomText(
                              text: Strings.check_your_email,
                              align: TextAlign.center,
                              fontSize: Dimensions.normalFont),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                      onTap: () {
                        MagicRouter.navigateTo(const OTPPage());
                      },
                      text: 'متابعة'),
                ],
              ),
            ),
          ),
        ));
  }
}
