import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:popover/popover.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/custom_appbar.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/core/widgets/loading_circle.dart';
import 'package:zawaj/features/home/data/models/home_model.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/send_report/presentation/screen/send_report.dart';

class PartnerDetailsScreen extends StatelessWidget {
  const PartnerDetailsScreen({super.key, required this.homeModel});
  final HomeModel homeModel;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isFullScreen: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppBar(
                isHeartTitle: true,
                leading: MenuReportButton(homeModel: homeModel)),
            InfoLabel(homeModel: homeModel),
          ],
        ),
      ),
    );
  }
}

class MenuReportButton extends StatelessWidget {
  const MenuReportButton({
    super.key,
    required this.homeModel,
  });
  final HomeModel homeModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showPopover(
          backgroundColor: Colors.transparent,
          direction: PopoverDirection.top,
          context: context,
          bodyBuilder: (context) => ReportCard(homeModel: homeModel),
          radius: 25,
          width: 250,
        );
      },
      child: const Padding(
          padding: EdgeInsets.all(0),
          child: Icon(
              color: ColorManager.primaryColor,
              size: 30,
              Icons.more_horiz_outlined)),
    );
  }
}

class InfoLabel extends StatelessWidget {
  const InfoLabel({super.key, required this.homeModel});

  final HomeModel homeModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CarouselSlider(
            items: homeModel.images!.map((image) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  EndPoints.BASE_URL_image + image,
                  width: context.width,
                  height: context.height * 0.3,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.white,
                      width: context.width,
                      height: context.height * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Image.asset(
                              ImageManager.profileError,
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    return child;
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return const Center(
                        child: LoadingCircle(),
                      );
                    }
                  },
                ),
              );
            }).toList(),
            options: CarouselOptions(autoPlay: true, enlargeCenterPage: true),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomText(
                    lines: 6,
                    align: TextAlign.start,
                    text: '${homeModel.name}, ${homeModel.age}',
                    fontSize: Dimensions.largeFont,

                    // textOverFlow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                CustomText(
                  text: homeModel.city,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: CustomText(
              text: homeModel.about,
              fontSize: Dimensions.normalFont,
              align: TextAlign.start,
            )),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Wrap(
          spacing: 25,
          runSpacing: 10,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 3.2 - 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                      color: ColorManager.hintTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      text: "العمر"),
                  CustomText(
                    text: homeModel.age.toString(),
                    color: ColorManager.primaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  )
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3.2 - 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                      color: ColorManager.hintTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      text: "الحالة الاجتماعية"),
                  CustomText(
                    text: homeModel.maritalStatus == 'Single' &&
                            homeModel.gender == 'Female'
                        ? 'عزباء'
                        : homeModel.maritalStatus == 'Single'
                            ? 'اعزب'
                            : homeModel.maritalStatus == 'Married' &&
                                    homeModel.gender == 'Female'
                                ? 'متزوجة'
                                : homeModel.maritalStatus == 'Married'
                                    ? 'متزوج'
                                    : homeModel.maritalStatus == 'HeDivorced'
                                        ? 'مطلّق'
                                        : homeModel.maritalStatus ==
                                                'SheDivorced'
                                            ? 'مطلّقة'
                                            : homeModel.maritalStatus ==
                                                        'DivorcedWithChildern' &&
                                                    homeModel.gender == 'Female'
                                                ? 'مطلّقة بأطفال'
                                                : homeModel.maritalStatus ==
                                                        'DivorcedWithChildern'
                                                    ? 'مطلّق بأطفال'
                                                    : homeModel.maritalStatus ==
                                                                'DivorcedWithoutChildern' &&
                                                            homeModel.gender ==
                                                                'Female'
                                                        ? 'مطلّقة بدون أطفال'
                                                        : homeModel.maritalStatus ==
                                                                'DivorcedWithoutChildern'
                                                            ? 'مطلّق بدون أطفال'
                                                            : homeModel.maritalStatus ==
                                                                        'Widower' &&
                                                                    homeModel
                                                                            .gender ==
                                                                        'Female'
                                                                ? 'أرملة'
                                                                : homeModel.maritalStatus ==
                                                                        'Widower'
                                                                    ? 'أرمل'
                                                                    : homeModel.maritalStatus ==
                                                                            'Other'
                                                                        ? 'أخرى'
                                                                        : '',
                    color: ColorManager.primaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  )
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3.2 - 30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                      color: ColorManager.hintTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      text: "المنطقة"),
                  CustomText(
                    text: homeModel.area,
                    color: ColorManager.primaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3.2 - 30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                      color: ColorManager.hintTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      text: "الوزن"),
                  CustomText(
                    text: homeModel.weight.toString(),
                    color: ColorManager.primaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3.2 - 30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                      color: ColorManager.hintTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      text: "الطول"),
                  CustomText(
                    text: homeModel.height.toString(),
                    color: ColorManager.primaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3.2 - 30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                      color: ColorManager.hintTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      text: "الديانة"),
                  CustomText(
                    text: homeModel.religion == 'Muslim' ? 'مسلم' : 'مسيحي',
                    color: ColorManager.primaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),
            ParametersList(parameters: homeModel.parameters)
          ],
        ),
      ],
    );
  }
}

class ReportCard extends StatelessWidget {
  const ReportCard({super.key, required this.homeModel});
  final HomeModel homeModel;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 3.2 - 30,
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(Dimensions.buttonRadius),
                  topEnd: Radius.circular(Dimensions.buttonRadius),
                  bottomStart: Radius.circular(Dimensions.buttonRadius))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () {
                      MagicRouter.navigateTo(SendReport(
                        userId: homeModel.userId.toString(),
                        userName: homeModel.name.toString(),
                      ));
                    },
                    child: const CustomText(text: Strings.report_user)),
              ],
            ),
          ),
        ));
  }
}

class ParametersList extends StatelessWidget {
  const ParametersList({super.key, required this.parameters});

  final List<Parameter>? parameters;

  @override
  Widget build(BuildContext context) {
    if (parameters == null || parameters!.isEmpty) {
      return Container();
    }
    return Wrap(
      spacing: 25,
      runSpacing: 10,
      children: parameters!.map((parameter) {
        return SizedBox(
          width: MediaQuery.of(context).size.width / 3.2 - 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                color: ColorManager.hintTextColor,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                text: parameter.valueName == 'لا شيء مما سبق'
                    ? ''
                    : parameter.parameterName ?? '',
              ),
              CustomText(
                text: parameter.valueName == 'لا شيء مما سبق'
                    ? ''
                    : parameter.valueName ?? '',
                color: ColorManager.primaryTextColor,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
