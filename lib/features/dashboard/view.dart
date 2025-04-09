import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/features/dashboard/cubit.dart';
import 'package:zawaj/features/dashboard/states.dart';

class DashBoardScreen extends StatelessWidget {
  final int initialIndex;
  const DashBoardScreen({super.key, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    DashBoardCubit cubit = DashBoardCubit.get(context);
    cubit.changeIndex(initialIndex);
    return BlocConsumer<DashBoardCubit, DashboardState>(
      listener: (context, state) {},
      builder: (context, state) => CustomScaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                unselectedItemColor: ColorManager.hintTextColor,
                showUnselectedLabels: true,
                enableFeedback: false,
                unselectedFontSize: 14,
                elevation: 10,
                selectedLabelStyle: GoogleFonts.cairo(
                    textStyle: const TextStyle(
                  fontSize: 15,
                )),
                unselectedLabelStyle: GoogleFonts.cairo(
                    textStyle: const TextStyle(
                  fontSize: 13,
                )),
                selectedItemColor: ColorManager.primaryColor,
                currentIndex: cubit.currentIndex,
                items: [
                  BottomNavigationBarItem(
                      icon: SvgPicture.asset(cubit.currentIndex == 0
                          ? ImageManager.heart_colored
                          : ImageManager.heart),
                      label: 'أعجبوني'),
                  BottomNavigationBarItem(
                      icon: SvgPicture.asset(cubit.currentIndex == 1
                          ? ImageManager.chat_colored
                          : ImageManager.chat),
                      label: 'المحادثات'),
                  BottomNavigationBarItem(
                      icon: SvgPicture.asset(cubit.currentIndex == 2
                          ? ImageManager.home_colored
                          : ImageManager.home),
                      label: 'الرئيسية'),
                  BottomNavigationBarItem(
                      icon: SvgPicture.asset(ImageManager.notification,
                          color: cubit.currentIndex == 3
                              ? ColorManager.primaryColor
                              : ColorManager.hintTextColor),
                      label: 'الاشعارات'),
                  BottomNavigationBarItem(
                    icon: Icon(
                        cubit.currentIndex == 4
                            ? Icons.person
                            : Icons.person_outline_rounded,
                        color: cubit.currentIndex == 4
                            ? ColorManager.primaryColor
                            : ColorManager.hintTextColor),
                    label: 'حسابي ',
                  ),
                ],
                onTap: (i) {
                  cubit.changeIndex(i);
                },
              ),
            ),
          ),
          child: cubit.pages[cubit.currentIndex]),
    );
  }
}
