import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/core/widgets/toast.dart';

import '../login_signup/login_page.dart';

class SuccessNewPassword extends StatelessWidget {
  const SuccessNewPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: AppBar(
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: ColorManager.primaryColor),
          automaticallyImplyLeading: false,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: context.height,
                  width: context.width,
                  color: ColorManager.primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.defaultPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: context.height * 0.2,
                        ),
                        Container(
                          padding: const EdgeInsets.all(30),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: const Center(
                              child: Icon(
                            Icons.done,
                            size: 100,
                            color: ColorManager.primaryColor,
                          )),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(35),
                          child: CustomText(
                            text: Strings.re_enter_pass,
                            color: Colors.white,
                          ),
                        ),
                        CustomButton(
                          onTap: () {
                            //MagicRouter.navigateAndPopAll(const LoginPage());
                            MagicRouter.navigateTo(LoginPage());
                            //   MagicRouter.navigateAndReplacement(LoginPage());
//showToast(msg: "msg");
                          },
                          text: Strings.LOGIN_NOW,
                          color: Colors.white,
                          txtColor: ColorManager.primaryColor,
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ));
  }
}
