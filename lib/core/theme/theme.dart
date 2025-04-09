import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/color_manager.dart';

ThemeData themeData = ThemeData(
  // primaryColor: ColorManager.primaryColor,
  // canvasColor:ColorManager.primaryColor,
  appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark)),

  scaffoldBackgroundColor: Colors.white,

  // fontFamily: //"Tajawal", //Sakkal Majalla
  textTheme: GoogleFonts.cairoTextTheme(),

  colorScheme: ThemeData().colorScheme.copyWith(
        primary: ColorManager.primaryColor,
      ),
);
