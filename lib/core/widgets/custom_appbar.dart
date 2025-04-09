import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:popover/popover.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/extensions/bottom_sheet.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/features/home/presentation/pages/partner_details_screen.dart';
import 'package:zawaj/features/profile/presentation/pages/profile_page.dart';
import 'package:zawaj/features/setup_account/presentation/pages/set_partenal_data.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar(
      {super.key,
      this.isBack = true,
      this.title,
      this.titleFontWeight,
      this.isLogoTitle = false,
      this.leading,
      this.isHeartTitle = false,
      this.isMenuIcon = false,
      this.isSettingIcon = false,
      this.isShowOthers = false});
  final bool isBack;
  final bool isLogoTitle;
  final bool isHeartTitle;
  final bool isMenuIcon;
  final bool isSettingIcon;
  final String? title;
  final FontWeight? titleFontWeight;
  final Widget? leading;
  final bool isShowOthers;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    Widget titleWidget;

    if (widget.isLogoTitle) {
      titleWidget = Image.asset(
        ImageManager.logo,
        //   scale: 1,
        height: context.height * 0.1,
        width: context.width * 0.6,
      );
    } else if (widget.isHeartTitle) {
      titleWidget = SvgPicture.asset(ImageManager.heartLogo);
    } else {
      titleWidget = CustomText(
        text: widget.title,
        fontWeight: widget.titleFontWeight ?? FontWeight.w400,
        fontSize: 20,
      );
    }

    Widget actionWidget;
    if (widget.isBack) {
      actionWidget = const ActionApp();
    } else if (widget.isMenuIcon) {
      actionWidget = const MenuButton();
    } else if (widget.isSettingIcon) {
      actionWidget = const SettingIcon();
    } else {
      actionWidget = const SizedBox();
    }
    /*
    Widget leadingWidget;
    if (widget.isSettingIcon) {
      leadingWidget = const SettingIcon();
    } else {
      leadingWidget = const SizedBox();
    }
*/
    return AppBar(
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: titleWidget,
      actions: [actionWidget],
      leading: widget.leading,
      //leadingWidget,
    );
  }
}

class ActionApp extends StatelessWidget {
  const ActionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          MagicRouter.goBack();
        },
        child: const Icon(
          Icons.arrow_forward,
          color: ColorManager.hintTextColor,
        ));
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showPopover(
            context: context,
            bodyBuilder: (context) => const OtherEditsPopUp(),
            backgroundColor: Colors.transparent,
            radius: 25,
            width: 250);
      },
      child: SvgPicture.asset(
        ImageManager.menuIcon,
        fit: BoxFit.scaleDown,
      ),
    );
  }
}

class SettingIcon extends StatelessWidget {
  const SettingIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        MagicRouter.navigateTo(SetPartnerData(isUpdated: true));
      },
      child: SvgPicture.asset(
        ImageManager.settingIcon,
        fit: BoxFit.scaleDown,
      ),
    );
  }
}
