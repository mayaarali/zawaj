import 'package:flutter/material.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/custom_appbar.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/features/setup_account/presentation/pages/set_partenal_data.dart';

class YourProfileIsComplete extends StatelessWidget {
  const YourProfileIsComplete({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: CustomButton(
          text: 'ابدأ البحث عن شريكك الآن',
          onTap: () {
            MagicRouter.navigateTo(SetPartnerData(
              isUpdated: false,
            ));
          },
        ),
      ),
      body: Column(
        children: [
          const CustomAppBar(
            isHeartTitle: true,
            isBack: false,
          ),
          Padding(
            padding: EdgeInsets.only(left: context.width * 0.3),
            child: Image.asset(
              ImageManager.congratulations,
              height: 350.0,
              width: 350.0,
            ),
          ),
          const CustomText(
            text: 'تهانينا',
            fontSize: 25,
          ),
          SizedBox(
            height: context.height * 0.015,
          ),
          const CustomText(
            text: 'ملفك الشخصي قد اكتمل ',
            color: Colors.black,
            fontSize: 20,
          ),
        ],
      ),
    );
  }
}
