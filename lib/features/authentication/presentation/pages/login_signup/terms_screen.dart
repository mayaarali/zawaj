import 'package:flutter/material.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/custom_appbar.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/features/profile/presentation/pages/verification/verify_account_screen.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  bool? value1 = false;
  bool? value2 = false;
  bool get areCheckboxesSelected => value1 == true && value2 == true;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isFullScreen: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(30),
        child: CustomButton(
            onTap: areCheckboxesSelected
                ? () {
                    MagicRouter.navigateTo(VerifyScreen());
                  }
                : () => context.getSnackBar(
                    snackText: 'من فضلك وافق على الشروط', isError: true),
            text: Strings.next),
      ),
      child: Column(
        children: [
          const CustomAppBar(
            isBack: false,
            isLogoTitle: true,
          ),
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 60),
                child: CustomText(
                  text: Strings.safteyInsurance,
                  fontSize: Dimensions.largeFont,
                ),
              ),
              const CustomText(
                text: Strings.commited,
                align: TextAlign.start,
                color: ColorManager.greyTextColor,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Checkbox(
                      value: value2,
                      onChanged: (bool? value) {
                        setState(() {
                          value2 = value;
                        });
                      }),
                  const CustomText(
                    text: Strings.agreeTerms,
                    align: TextAlign.start,
                    color: ColorManager.greyTextColor,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                      value: value1,
                      onChanged: (bool? value) {
                        setState(() {
                          value1 = value;
                        });
                      }),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: context.height * 0.02),
                      child: CustomText(
                        text: Strings.swear,
                        align: TextAlign.start,
                        color: ColorManager.greyTextColor,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
