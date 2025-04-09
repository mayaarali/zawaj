import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/widgets/custom_appbar.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/core/widgets/custom_text_field.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/consultants/data/models/consultants_model.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/consultants/presentation/bloc/consultant_bloc.dart';

class ConsultantsScreen extends StatefulWidget {
  const ConsultantsScreen({super.key});

  @override
  State<ConsultantsScreen> createState() => _ConsultantsScreenState();
}

class _ConsultantsScreenState extends State<ConsultantsScreen> {
  @override
  void initState() {
    ConsultantBloc.get(context).getConsultantData();
    ConsultantBloc.get(context).searchController.clear();
    ConsultantBloc.get(context).scrollController.addListener(() {
      if (ConsultantBloc.get(context).scrollController.position.pixels ==
          ConsultantBloc.get(context)
              .scrollController
              .position
              .maxScrollExtent) {
        ConsultantBloc.get(context).getConsultantData(loadMore: true);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    ConsultantBloc.get(context).scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConsultantBloc, ConsultantState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is ConsultantLoading) {
          return GestureDetector(
            onTap: () {
              print('Unfocus************************');
              FocusScope.of(context).unfocus();
            },
            child: const CustomScaffold(
              isFullScreen: true,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      surfaceTintColor: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CupertinoActivityIndicator(
                              color: ColorManager.primaryColor,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'تحميل ...',
                              style: TextStyle(
                                  color: ColorManager.primaryTextColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (state is ConsultantSuccess) {
          final uniqueUsers = state.consultantList.toSet().toList();
          final consultantList = state.consultantList;

          return CustomScaffold(
              isFullScreen: true,
              child: Column(
                children: [
                  const CustomAppBar(
                    title: Strings.consultant,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          suffixIcon: InkWell(
                            child: const Icon(Icons.search),
                            onTap: () {
                              ConsultantBloc.get(context).getConsultantData();
                            },
                          ),
                          controller:
                              ConsultantBloc.get(context).searchController,
                          hintText: 'ابحث  ...',
                          height: 60,
                          onFieldSubmitted: (value) {
                            ConsultantBloc.get(context).getConsultantData();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: ConsultantBloc.get(context)
                          .scrollController, // Pass the controller
                      itemCount: uniqueUsers.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == uniqueUsers.length) {
                          return ConsultantBloc.get(context).isLoadingMore
                              ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: LinearProgressIndicator(
                                    color: ColorManager.primaryColor,
                                  ),
                                )
                              : Container();
                        }
                        return ConsultantDataWidget(
                            consultantModel: consultantList[index]);
                      },
                    ),
                  )
                ],
              ));
        } else {
          return const CustomScaffold(
            isFullScreen: true,
            child: Center(
              child: Text(''),
            ),
          );
        }
      },
    );
  }
}

class ConsultantDataWidget extends StatelessWidget {
  ConsultantDataWidget({super.key, required this.consultantModel});
  final ConsultantModel consultantModel;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConsultantBloc, ConsultantState>(
      listener: (context, state) {},
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            print('Unfocus************************');
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Row(
                children: [
                  const CustomText(
                    text: 'الاسم:',
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  CustomText(text: consultantModel.name),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    text: 'رقم الهاتف:',
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  CustomText(text: consultantModel.phone),
                  // const SizedBox(
                  //   width: 5,
                  // ),
                  // const Spacer(),
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: CustomText(
                  //     textDecoration: TextDecoration.underline,
                  //     color: ColorManager.greyTextColor,
                  //     fontSize: 10,
                  //     align: TextAlign.end,
                  //     text: 'عدد النقرات: ${consultantModel.clickCount}',
                  //     // fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CustomText(
                    text: 'العنوان:',
                    fontWeight: FontWeight.bold,
                    align: TextAlign.start,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: CustomText(
                        text: consultantModel.address,
                        textOverFlow: TextOverflow.ellipsis,
                        lines: 3,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const CustomText(
                    text: 'الخدمة:',
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  CustomText(text: consultantModel.service),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                hoverColor: ColorManager.primaryColor,
                highlightColor: ColorManager.primaryColor,
                onTap: () {
                  ConsultantBloc.get(context)
                      .makePhoneCall(consultantModel.phone!);
                  ConsultantBloc.get(context).add(
                      ClickConsultantEvent(consultantId: consultantModel.id!));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                          Radius.circular(Dimensions.buttonRadius)),
                      border: Border.all(
                        color: ColorManager.primaryColor,
                      )),
                  padding: const EdgeInsets.all(15),
                  //width: MediaQuery.of(context).size.width * .1,
                  // height:
                  //     //Dimensions(context: context).buttonHeight,
                  //     MediaQuery.of(context).size.height * .05,
                  child: const Center(
                    child: Icon(
                      Icons.call,
                      color: ColorManager.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Divider(
                color: ColorManager.hintTextColor.withOpacity(0.5),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }
}
