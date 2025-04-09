import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/widgets/custom_text.dart';

import '../../../../core/constants/strings.dart';

class EmptyNotification extends StatelessWidget {
  const EmptyNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        // const CustomText(text: Strings.empty_notif),

        Center(
          child: SvgPicture.asset(
            ImageManager.notificationLogo,
            width: context.width * 0.45,
            height: context.height * 0.2,
            color: ColorManager.primaryTextColor,
          ),
        )
      ],
    );
  }
}
