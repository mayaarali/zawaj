import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/build_dialog.dart';
import 'package:zawaj/core/widgets/custom_appbar.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/features/payment/presentation/pages/payment_possibilities.dart';

class ChooseBundle extends StatelessWidget {
  const ChooseBundle(
      {super.key, required this.userId, required this.isFromProfileScreen});
  final String userId;
  final bool isFromProfileScreen;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(30),
        child: CustomButton(
            onTap: () {
              MagicRouter.navigateTo(PayementPossibility(
                isFromProfileScreen: isFromProfileScreen,
              ));
            },
            text: Strings.continu),
      ),
      isFullScreen: true,
      child: const SingleChildScrollView(
        child: Column(
          children: [
            CustomAppBar(
              isLogoTitle: true,
            ),
            SizedBox(
              height: 50,
            ),
            CustomText(
              text: Strings.golden_bundle,
              fontSize: Dimensions.largeFont,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(
              height: 30,
            ),
            //    Image.asset(ImageManager.heart_message),
            // const Padding(
            //   padding: EdgeInsets.symmetric(vertical: 30),
            //   child: CustomText(
            //     text: Strings.golden_bundle,
            //     fontSize: Dimensions.normalFont,
            //   ),
            // ),

            SizedBox(
              height: 5,
            ),
            //  TextButton(
            //      onPressed: () {},
            //      child: const Text(
            //        Strings.cancelpills,
            //        style: TextStyle(
            //          color: ColorManager.hintTextColor,
            //        ),
            //      )),
            CustomText(
              align: TextAlign.start,
              text: Strings.free_bundle_instructions,
              color: ColorManager.darkGrey,
              //fontSize: 20,
            )
          ],
        ),
      ),
    );
  }
}
