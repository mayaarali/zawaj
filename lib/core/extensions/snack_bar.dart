import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/widgets/custom_text.dart';

extension SnackBarEextension on BuildContext {
  void getSnackBar({
    required String snackText,
    String? snackHelperText,
    bool isError = false,
    //   required BuildContext context
  }) =>
      showDialog(
          context: this,
          barrierDismissible: true,
          barrierColor: ColorManager.primaryColor.withOpacity(0.5),
          builder: (context) => AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                title: isError
                    ? const Column(children: [
                        Icon(
                          Icons.warning_rounded,
                          color: ColorManager.primaryColor,
                          size: 50,
                        ),
                      ])
                    : const Column(children: [
                        Icon(
                          Icons.check_circle_outline_outlined,
                          color: ColorManager.primaryColor,
                          size: 50,
                        ),
                      ]),
                content: PopUpAlert(
                  msg: snackText,
                  msgHelper: snackHelperText,
                ),
              ));
  //  ScaffoldMessenger.of(this).showSnackBar(
  //   SnackBar(
  //   backgroundColor: isError
  //       ? ColorManager.primaryColor
  //       : ColorManager.secondaryPinkColor,
  //   behavior: SnackBarBehavior.floating,
  //   margin: const EdgeInsets.all(10),
  //   content: Text(
  //     snackText.tr(),
  //     style: TextStyle(
  //         color: isError
  //             ? Colors.white
  //             : ColorManager.primaryColor // Set the desired text color here
  //         ),
  //   ),
  //   duration: const Duration(seconds: 1),
  // )
  //);
}

class PopUpAlert extends StatelessWidget {
  PopUpAlert({super.key, this.msg, this.msgHelper});
  String? msg;
  String? msgHelper;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(
          text: msg,
          fontSize: Dimensions.mediumFont,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(
          height: 10,
        ),
        CustomText(
          text: msgHelper,
          fontSize: Dimensions.smallFont,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}
