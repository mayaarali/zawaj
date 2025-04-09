import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zawaj/core/constants/color_manager.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final Color? color;
  final double? fontSize;
  final FontWeight fontWeight;
  final TextAlign? align;
  final double? height;
  final TextDirection? textDirection;
  final int? lines;
  final TextOverflow? textOverFlow;
  final TextDecoration? textDecoration;
  final Color? decorationColor;

  const CustomText(
      {super.key,
      this.lines,
      this.textDirection,
      this.height,
      this.align,
      required this.text,
      this.color,
      this.fontSize,
      this.textDecoration,
      this.fontWeight = FontWeight.normal,
      this.textOverFlow,
      this.decorationColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      text == null ? '' : text!.tr(),
      textDirection: textDirection,
      softWrap: true,

      style: GoogleFonts.cairo(
          textStyle: TextStyle(
        decoration: textDecoration ?? TextDecoration.none,
        height: height,
        decorationColor: decorationColor ?? Colors.black,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? ColorManager.primaryTextColor,
        overflow: textOverFlow,
      )),
      //   TextStyle(
      //    decoration: textDecoration ?? TextDecoration.none,
      //    height: height,
      //    fontSize: fontSize,
      //    fontWeight: fontWeight,
      //    color: color ?? ColorManager.primaryTextColor,
      //    overflow: textOverFlow,
      //    // fontFamily: 'Tajawal',
      //  ),
      maxLines: lines,
      //overflow: TextOverflow.ellipsis,
      textAlign: align ?? TextAlign.center,
    );
  }
}
