import 'package:flutter/material.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';

class CheckInternetConnection extends StatelessWidget {
  const CheckInternetConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_outlined,
              size: 120,
              color: ColorManager.primaryColor,
            ),
            CustomText(
              text: 'تحقق من الاتصال بالانترنت !',
              fontWeight: FontWeight.bold,
            )
          ],
        ),
      ),
    );
  }
}
