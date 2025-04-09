import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zawaj/core/constants/color_manager.dart';

showToast(
    {required String msg,
    state,
    ToastGravity gravity = ToastGravity.TOP,
    Color color = Colors.black,
    Color textColor = ColorManager.primaryTextColor,
    Color background = ColorManager.secondaryPinkColor}) {
  Fluttertoast.showToast(
      msg: msg.tr(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: 5,
      backgroundColor: background,
      textColor: textColor,
      fontSize: 16.0);
}

enum ToastedStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastedStates states) {
  Color color;
  switch (states) {
    case ToastedStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastedStates.ERROR:
      color = Colors.red;
      break;
    case ToastedStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}
