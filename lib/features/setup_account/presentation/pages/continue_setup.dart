import 'package:flutter/material.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/custom_appbar.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'choose_images.dart';

class ContinueSetUp extends StatelessWidget {
  const ContinueSetUp({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        isFullScreen: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CustomAppBar(
              title: '',
              isLogoTitle: true,
              isBack: true,
            ),
            SizedBox(
              height: context.height * 0.1,
            ),
            const CustomText(
              fontSize: 18,
              text: Strings.continue_setup,
              fontWeight: FontWeight.bold,
            ),
            const Spacer(),
            CustomButton(
              text: Strings.next,
              onTap: () {
                MagicRouter.navigateTo(ChooseImages());
              },
            ),
          ],
        ));
  }
}
