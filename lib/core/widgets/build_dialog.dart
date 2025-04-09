import 'package:flutter/material.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_text.dart';

Future buildDialog({
  context,
  required void Function() onTapEnter,
  void Function()? onTapCancell,
  required String buttonTitle,
  required String? title,
  required String desc,
  bool isDissmiss = true,
  bool isDoubleBtn = false,
  String? optionalButtonTitle,
  void Function()? onTapOptional,
  bool isIcon = false,
  var isIconImage,
}) {
  return showDialog(
      context: context,
      barrierDismissible: isDissmiss,
      barrierColor: ColorManager.primaryColor.withOpacity(0.5),
      builder: (context) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            title: title == null
                ? null
                : isIcon
                    ? Column(
                        children: [
                          isIconImage!,
                          const SizedBox(
                            height: 5,
                          ),
                          CustomText(
                            text: title,
                            fontSize: Dimensions.largeFont,
                          ),
                        ],
                      )
                    : CustomText(
                        text: title,
                        fontSize: Dimensions.largeFont,
                      ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                  text: desc,
                  fontWeight: FontWeight.normal,
                  align: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomButton(onTap: onTapEnter, text: buttonTitle),
                const SizedBox(
                  height: 5,
                ),
                if (isDoubleBtn == true)
                  CustomButton(
                    onTap: onTapCancell,
                    text: optionalButtonTitle,
                    txtColor: ColorManager.primaryColor,
                    borderColor: ColorManager.primaryColor,
                    color: Colors.white.withOpacity(0.25),
                  )
              ],
            ),
          ));
}
