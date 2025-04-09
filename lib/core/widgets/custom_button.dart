import 'package:flutter/material.dart';
import 'package:zawaj/core/constants/dimensions.dart';

import '../../core/constants/color_manager.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final GestureTapCallback? onTap;
  final String? text;
  final double? width;
  final double? height;
  final Widget? iconWidget;
  final bool? isGap;
  final Color? color;
  final Color? txtColor;
  final bool? isColored;
  final Color? borderColor;
  final double? fontSize;
  final double? radius;

  const CustomButton(
      {super.key,
      required this.onTap,
      this.iconWidget,
      required this.text,
      this.width,
      this.height,
      this.isGap,
      this.color,
      this.txtColor,
      this.radius,
      this.isColored = true,
      this.borderColor,
      this.fontSize});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: width,
          height: height ?? Dimensions(context: context).buttonHeight,
          decoration: BoxDecoration(
              color: color ?? ColorManager.primaryColor,
              borderRadius:
                  BorderRadius.circular(radius ?? Dimensions.buttonRadius),
              border: Border.all(color: borderColor ?? Colors.transparent)),
          child: Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              mainAxisAlignment: iconWidget == null
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  lines: 2,
                  text: text,
                  color: txtColor ?? (isColored!
                          ? Colors.white
                          : ColorManager.primaryColor),
                  fontSize: fontSize ?? 16,
                ),
                iconWidget == null ? const SizedBox() : iconWidget!
              ],
            ),
          ))),
    );
  }
}
