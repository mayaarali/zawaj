import 'package:flutter/material.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/custom_appbar.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text_field.dart';
import 'package:zawaj/features/authentication/presentation/pages/otp/otp_page.dart';

class EnterPhonePage extends StatelessWidget {
  const EnterPhonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        child: Padding(
      padding: const EdgeInsets.all(Dimensions.defaultPadding),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CustomAppBar(
              title: Strings.enter_phone,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: CustomTextField(
                hintText: Strings.phone_no,
              ),
            ),
            CustomButton(
                onTap: () {
                  MagicRouter.navigateTo(const OTPPage());
                },
                text: Strings.next)
          ],
        ),
      ),
    ));
  }
}
