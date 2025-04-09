import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/extensions/sizes.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold(
      {super.key,
      required this.child,
      this.bottomNavigationBar,
      this.backgroundColor,
      this.isFullScreen = false,
      this.appBar});
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final bool isFullScreen;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: context.locale == const Locale('en')
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
        bottomNavigationBar: bottomNavigationBar,
        backgroundColor: backgroundColor ?? ColorManager.backgroundColor,
        body: isFullScreen
            ? SizedBox(
                height: context.height,
                width: context.width,
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: Dimensions.defaultPadding,
                      bottom: Dimensions.defaultPadding,
                      left: Dimensions.defaultPadding),
                  child: child,
                ),
              )
            : child,
        appBar: PreferredSize(
          preferredSize: const Size(0, 0),
          child: appBar ??
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Colors.white,
                    statusBarIconBrightness: Brightness.dark),
                automaticallyImplyLeading: false,
              ),
        ),
      ),
    );
  }
}
