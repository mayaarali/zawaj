import 'dart:developer';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/core/widgets/custom_appbar.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/core/widgets/loading_circle.dart';
import 'package:zawaj/features/payment/data/models/payment_model.dart';
import 'package:zawaj/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:zawaj/features/payment/presentation/pages/payment_webview.dart';
import 'package:zawaj/features/profile/presentation/bloc/profile_bloc.dart';

import '../../../../core/router/routes.dart';

class PayementPossibility extends StatefulWidget {
  const PayementPossibility({super.key, required this.isFromProfileScreen});
  final bool isFromProfileScreen;

  @override
  State<PayementPossibility> createState() => _PayementPossibilityState();
}

class _PayementPossibilityState extends State<PayementPossibility> {
  bool isSelected1 = true;
  bool isSelected2 = false;

  @override
  void initState() {
    //CacheHelper.setData(key: Strings.isSubscribed, value: true);

    PaymentBloc.get(context).getPaymentPlan();
    PaymentBloc.get(context).getPaymentStandardPlan();
    ProfileBloc.get(context).getMyProfile();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isFullScreen: true,
      bottomNavigationBar: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          return state is PaymentLoading
              ? const SizedBox()
              : Padding(
                  padding:
                      const EdgeInsets.only(right: 25, left: 25, bottom: 8),
                  child: CustomButton(
                      onTap: () {
                        final paymentBloc = PaymentBloc.get(context);
                        paymentBloc.add(ChoosePlan(
                          id: paymentBloc.planId,
                          standardValue: paymentBloc.standardValuePayment,
                        ));
                        log('********************planId AT CHOOOSE PAAAYMENNNTTTTT*************************');
                        log(
                          paymentBloc.planId,
                        );
                      },
                      text: Strings.payNow),
                );
        },
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            CustomAppBar(
              isBack: widget.isFromProfileScreen == true ? true : false,
              title: Strings.payementPossibility,
              titleFontWeight: FontWeight.bold,
            ),
            const SizedBox(
              height: 20,
            ),
            ExpandableBody(
              isFromProfileScreen: widget.isFromProfileScreen,
            ),
          ],
        ),
      ),
    );
  }
}

class PayementExpandedPanel extends StatelessWidget {
  const PayementExpandedPanel(
      {super.key, required this.header, required this.expanded});
  final Widget expanded;
  final Widget header;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ExpandablePanel(
        theme: const ExpandableThemeData(
          iconColor: ColorManager.primaryColor,
          iconPlacement: ExpandablePanelIconPlacement.right,
        ),
        header: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
          child: Row(
            children: [
              header,
            ],
          ),
        ),
        collapsed: const SizedBox(),
        expanded: expanded,
      ),
    );
  }
}

class ExpandableBody extends StatelessWidget {
  const ExpandableBody({super.key, required this.isFromProfileScreen});
  final bool isFromProfileScreen;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) async {
      if (state is PaymentLoading) {
        const Center(child: LoadingCircle());
      }
      //  String? url = await CacheHelper.getData(key: Strings.url);
      if (state is ChoosePlanSuccess) {
        log('choooooseeee plaannn dooonneeee');
        // context.getSnackBar(snackText: "تم اختيار الرزمة  ");
        ProfileBloc.get(context).getMyProfile();
        //  launchUrlSite(url: url);
        MagicRouter.navigateTo(WebViewScreen(
          userId: ProfileBloc.get(context).profileData!.id.toString(),
          isFromProfileScreen: isFromProfileScreen,
        ));
        // PaymentBloc.get(context).changePaymentData(
        //   index: '',
        // );
      }
      if (state is ChoosePlanFailure) {
        context.getSnackBar(snackText: "فشل في اختيار الرزمة  ", isError: true);
      }
    }, builder: (context, state) {
      return state is PaymentLoading || state is PaymentStandardLoading
          ? const Center(child: LoadingCircle())
          : Column(children: [
              isFromProfileScreen == true
                  ? const SizedBox()
                  : const Row(
                      children: [
                        CustomText(
                          text: 'الرزمة الاساسية',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        Spacer(),
                        // SvgPicture.asset(
                        //   ImageManager.lock,
                        //   width: 20,
                        //   height: 20,
                        //   fit: BoxFit.scaleDown,
                        // ),
                      ],
                    ),
              isFromProfileScreen == true
                  ? const SizedBox()
                  : const CustomText(
                      text:
                          "الرزمة الاساسية تمكنك من التصفح ومشاهدة الملاءمات واستقبال اشعارات من المعجبين",
                      fontSize: 15,
                      align: TextAlign.start,
                      fontWeight: FontWeight.w600,
                    ),
              SizedBox(
                height: isFromProfileScreen == false ? 20 : 0,
              ),
              isFromProfileScreen == true
                  ? const SizedBox()
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount:
                          PaymentBloc.get(context).standardPayList.length,
                      itemBuilder: (context, int index) {
                        return GestureDetector(
                          onTap: () {
                            final standardValue = parseToInt(
                                PaymentBloc.get(context)
                                    .standardPayList[index]
                                    .standardValue);

                            if (standardValue != null) {
                              PaymentBloc.get(context)
                                  .selectStandardPayIndex(index);

                              PaymentBloc.get(context).changePaymentData(
                                  index: index,
                                  standardValue: standardValue,
                                  amounts: standardValue,
                                  months: 1);
                              log(" standard value=> $standardValue");
                            } else {
                              log("Invalid standard value");
                            }
                          },
                          child: PlanCard(
                            currentIndex: index,
                            selectedIndex: PaymentBloc.get(context)
                                .selectedStandardPayIndex,
                            id: parseToInt(PaymentBloc.get(context)
                                .standardPayList[index]
                                .standardValue),
                            months: 1,
                            amount: parseToInt(PaymentBloc.get(context)
                                .standardPayList[index]
                                .standardValue),
                          ),
                        );
                      }),
              const SizedBox(
                height: 5,
              ),
              const Row(
                children: [
                  CustomText(
                    text: 'الرزمة الذهبيه',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  Spacer(),
                  // SvgPicture.asset(
                  //   ImageManager.lock,
                  //   width: 20,
                  //   height: 20,
                  //   fit: BoxFit.scaleDown,
                  // ),
                ],
              ),
              const CustomText(
                text:
                    "الرزمة الذهبيه تشمل خدمات الرزمة الاساسية بالاضافة الى الدردشة والتواصل المرئي والكتابي مع المرشحين الملائمين",
                fontSize: 15,
                align: TextAlign.start,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                height: 20,
              ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: PaymentBloc.get(context).payList.length,
                  itemBuilder: (context, int index) {
                    return GestureDetector(
                      onTap: () {
                        PaymentBloc.get(context).selectPayIndex(index);

                        PaymentBloc.get(context).changePaymentData(
                            index: index,
                            id: PaymentBloc.get(context).payList[index].id ?? 0,
                            amounts: PaymentBloc.get(context)
                                    .payList[index]
                                    .months ??
                                1,
                            months: PaymentBloc.get(context)
                                    .payList[index]
                                    .amount ??
                                1);
                      },
                      child: PlanCard(
                        currentIndex: index,
                        selectedIndex:
                            PaymentBloc.get(context).selectedPayIndex,
                        id: PaymentBloc.get(context).payList[index].id!,
                        months: PaymentBloc.get(context).payList[index].months!,
                        amount: PaymentBloc.get(context).payList[index].amount!,
                      ),
                    );
                  }),
              const SizedBox(
                height: 50,
              ),
            ]);
    });
  }

  int parseToInt(String value) {
    try {
      return int.parse(value);
    } catch (e) {
      return 0;
    }
  }
}

class PlanCard extends StatelessWidget {
  const PlanCard({
    super.key,
    required this.selectedIndex,
    required this.currentIndex,
    required this.id,
    required this.months,
    required this.amount,
  });

  final int selectedIndex;
  final int currentIndex;
  final int id;
  final int months;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.12,
      width: MediaQuery.of(context).size.width * 0.35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: currentIndex == selectedIndex
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  // spreadRadius: 8,
                  blurRadius: 2.0,
                  offset: const Offset(0.0, 8),
                )
              ]
            : [],
      ),
      child: Card(
        elevation: 3,
        color: ColorManager.backgroundColor,
        surfaceTintColor: Colors.transparent,
        shadowColor: ColorManager.secondaryPinkColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            width: 1.5,
            color: currentIndex == selectedIndex
                ? ColorManager.primaryColor
                : Colors.grey,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: '₪ $amount',
              fontWeight: FontWeight.bold,
            ),
            CustomText(
              text: months == 1
                  ? 'شهريآ'
                  : months == 2
                      ? 'شهرين'
                      : months > 10
                          ? '$months شهر'
                          : '$months شهور',
            ),
          ],
        ),
      ),
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    String inputData = newValue.text;
    StringBuffer buffer = StringBuffer();
    for (var i = 0; i < inputData.length; i++) {
      buffer.write(inputData[i]);
      int index = i + 1;
      if (index % 4 == 0 && inputData.length != index) {
        buffer.write("  ");
      }
    }
    return TextEditingValue(
        text: buffer.toString(),
        selection: TextSelection.collapsed(offset: buffer.toString().length));
  }
}

class CardMonthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    // String inputData = newValue.text;
    StringBuffer buffer = StringBuffer();
    for (var i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      var index = i + 1;
      if (index % 2 == 0 && newText.length != index) {
        buffer.write("/");
      }
    }

    return TextEditingValue(
        text: buffer.toString(),
        selection: TextSelection.collapsed(offset: buffer.toString().length));
  }
}
