import 'package:flutter/material.dart';

class Dimensions {
  final BuildContext? context;
  Dimensions({this.context});

  static const double defaultPadding = 25;
  static const double buttonRadius = 13;
  get buttonHeight => MediaQuery.of(context!).size.height * 0.07;
  get textFieldHeight => MediaQuery.of(context!).size.height * 0.07;
  static const double smallFont = 12;
  static const double largeFont = 25;
  static const double normalFont = 14;
  static const double mediumFont = 16;

  static const double dimen_60 = 60;
  static const double dimen_50 = 50;
  static const double dimen_40 = 40;
  static const double dimen_20 = 20;
  static const double dimen_10 = 10;
  static const double dimen_30 = 30;
}
