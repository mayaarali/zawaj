import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/core/widgets/loading_circle.dart';
import 'package:zawaj/features/setup_account/data/models/params_model.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/params_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/pages/choose_images.dart';
import 'package:zawaj/features/setup_account/presentation/pages/widgets/type_0.dart';
import 'package:zawaj/features/setup_account/presentation/pages/widgets/type_1.dart';
import 'package:zawaj/features/setup_account/presentation/pages/widgets/type_2&4.dart';
import 'package:zawaj/features/setup_account/presentation/pages/widgets/type_3.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../bloc/setup_bloc.dart';
import '../bloc/states.dart';
import '../widgets/main_params.dart';
import 'gender_screen.dart';

class SetPersonalData extends StatefulWidget {
  SetPersonalData({super.key});
  static final GlobalKey<FormState> paramsFormKey = GlobalKey<FormState>();

  @override
  State<SetPersonalData> createState() => _SetPersonalDataState();
}

class _SetPersonalDataState extends State<SetPersonalData> {
  bool isFirstTap = true;

  int paramsListLength = 0;
  @override
  void initState() {
    // if(SetUpBloc.get(context).isChecked.isEmpty){

    SetUpBloc.get(context)
        .fillSetupCollectList(ParamsBloc.get(context).paramsList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SetUpBloc bloc = SetUpBloc.get(context);

    return BlocConsumer<SetUpBloc, SetUpStates>(
      listener: (BuildContext context, SetUpStates state) {
        if (state is SuccessSetUp) {
          MagicRouter.navigateTo(ChooseImages());
        }
        if (state is FailedSetUp) {
          context.getSnackBar(snackText: state.message, isError: true);
        }
        if (state is GetParamsSuccess) {
          // SetUpBloc.get(context).fillSetupCollectList(state.paramsList);

          paramsListLength = state.paramsList.length;
        }
      },
      builder: (BuildContext context, SetUpStates state) => CustomScaffold(
          isFullScreen: true,
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(Dimensions.defaultPadding),
            child: state is LoadingSetUp
                ? SizedBox(
                    height: Dimensions(context: context).buttonHeight,
                    child: const LoadingCircle())
                // : Column(
                //     children: [
                : CustomButton(
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());

                      if (SetPersonalData.paramsFormKey.currentState!
                          .validate()) {
                        await SetUpBloc.get(context).changeMapValue(
                          key: "Height",
                          value: double.tryParse(SetUpBloc.get(context)
                                  .heightController
                                  .text) ??
                              0,
                        );
                        await SetUpBloc.get(context).changeMapValue(
                          key: "Weight",
                          value: double.tryParse(SetUpBloc.get(context)
                                  .weightController
                                  .text) ??
                              0,
                        );

                        List<ValueBody?> list = [];
                        Set<int> uniqueParamIds = Set();

                        for (int i = 0;
                            i <
                                SetUpBloc.get(context)
                                    .dropValueBodyList!
                                    .length;
                            i++) {
                          ValueBody? currentItem =
                              SetUpBloc.get(context).dropValueBodyList![i];
                          if (currentItem != null &&
                              !uniqueParamIds.contains(currentItem.paramId)) {
                            list.add(currentItem);
                            uniqueParamIds.add(currentItem.paramId ?? 0);
                          }
                        }

                        for (var element
                            in SetUpBloc.get(context).multiSelectList!) {
                          if (!uniqueParamIds.contains(element?.paramId)) {
                            list.add(element);
                            uniqueParamIds.add(element!.paramId ?? 0);
                          }
                        }

                        SetUpBloc.get(context).setUpMap.addEntries({
                              "selectionModel": List<dynamic>.from(
                                  list.map((x) => x!.toJson())),
                            }.entries);

                        log('this is set up map ${SetUpBloc.get(context).setUpMap}');

                        int selectionModelLength = SetUpBloc.get(context)
                                .setUpMap["selectionModel"]
                                ?.length ??
                            0;
                        log('selection model =>>>>>>>>>$selectionModelLength');
                        log('================>${ParamsBloc.get(context).paramsList.length}');
                        log('================>${list.length}');
                        log('=========uniqueParamIds=======>${uniqueParamIds.length}');
                        log('=========isFirstTap=======>${isFirstTap}');

                        if (SetUpBloc.get(context).setUpMap['MaritalStatus'] ==
                            null) {
                          context.getSnackBar(
                              snackText: 'يجب إضافة الحاله الاجتماعيه',
                              isError: true);
                        } else if (SetUpBloc.get(context).setUpMap['Religion'] ==
                            null) {
                          context.getSnackBar(
                              snackText: 'يجب إضافة الديانه', isError: true);
                        } else if (SetUpBloc.get(context)
                            .heightController
                            .text
                            .isEmpty) {
                          context.getSnackBar(
                              snackText: 'يجب إضافة طولك', isError: true);
                        } else if ((double.tryParse(SetUpBloc.get(context)
                                        .heightController
                                        .text) ??
                                    0) >
                                200 ||
                            (double.tryParse(SetUpBloc.get(context).heightController.text) ??
                                    0) <
                                0) {
                          context.getSnackBar(
                              snackText: 'الطول غير صحيح. اقصي طول [200-0]',
                              isError: true);
                        } else if (((double.tryParse(SetUpBloc.get(context)
                                        .weightController
                                        .text) ??
                                    0) >
                                200 ||
                            (double.tryParse(SetUpBloc.get(context).weightController.text) ??
                                    0) <
                                0)) {
                          context.getSnackBar(
                              snackText: 'الوزن غير صحيح. اقصي وزن [200-0]',
                              isError: true);
                        } else if (SetUpBloc.get(context)
                            .weightController
                            .text
                            .isEmpty) {
                          context.getSnackBar(
                              snackText: 'يجب إضافة وزنك', isError: true);
                        } else {
                          if (isFirstTap) {
                            if (ParamsBloc.get(context).paramsList.length !=
                                    uniqueParamIds.length ||
                                SetUpBloc.get(context)
                                    .setUpMap
                                    .containsValue(null)) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    content: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SvgPicture.asset(
                                              ImageManager.heartLogo),
                                          SizedBox(
                                            height: context.height * 0.04,
                                          ),
                                          const CustomText(
                                            text: Strings.increase_your_chance,
                                            fontSize: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [],
                                  );
                                },
                              );
                              isFirstTap = false;
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    content: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SvgPicture.asset(
                                              ImageManager.heartLogo),
                                          SizedBox(
                                            height: context.height * 0.04,
                                          ),
                                          const CustomText(
                                            text:
                                                Strings.complete_specifications,
                                            fontSize: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [],
                                  );
                                },
                              );
                              isFirstTap = false;
                            }
                          } else {
                            MagicRouter.navigateTo(ChooseImages());
                          }
                        }
                      }
                    },
                    text: Strings.next,
                  ),
            //    SizedBox(
            //      height: 5,
            //    ),
            //     GestureDetector(
            //       child: CustomText(
            //         text: Strings.changeEmail,
            //         color: ColorManager.greyTextColor,
            //         decorationColor: ColorManager.greyTextColor,
            //         textDecoration: TextDecoration.underline,
            //       ),
            //       onTap: () async {
            //         await FirebaseAuth.instance.signOut();
            //         GoogleSignIn googleSignIn = GoogleSignIn();
            //         googleSignIn.disconnect();

            //         await CacheHelper.removeData(key: Strings.token);
            //         await CacheHelper.removeData(key: Strings.hasSetup);
            //         await CacheHelper.removeData(
            //             key: Strings.hasRequired);
            //         await CacheHelper.removeAllData();
            //         MagicRouter.navigateAndPopAll(LoginPage());
            //       },
            //     )
            //   ],
            // ),
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CustomAppBar(
                  title: Strings.my_personal_data,
                  isBack: true,
                ),
                const CustomStepper(
                  pageNumber: 1,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                    alignment: Alignment.centerRight,
                    child: CustomText(
                      text: Strings.marital_status,
                      fontSize: 20,
                    )),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: SetPersonalData.paramsFormKey,
                  child: Expanded(
                    child: ListView(
                      children: [
                        MainParam(
                          heightController: bloc.heightController,
                          weightController: bloc.weightController,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const ParamsBody(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class ParamsBody extends StatelessWidget {
  const ParamsBody({super.key, this.isUpdate});
  final bool? isUpdate;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SetUpBloc, SetUpStates>(
      listener: (BuildContext context, SetUpStates s) {},
      builder: (BuildContext context, SetUpStates s) => BlocConsumer<ParamsBloc,
              SetUpStates>(
          listener: (BuildContext context, SetUpStates state) {
            if (state is GetParamsSuccess) {
              // if(SetUpBloc.get(context).isChecked.isEmpty){
              if (isUpdate == true) {
              } else {
                SetUpBloc.get(context).fillSetupCollectList(state.paramsList);
              }

              // }

              //
              // log(SetUpBloc.get(context).isChecked.length.toString());
            }
          },
          builder: (BuildContext context, SetUpStates state) => state
                  is GetParamsLoading
              ? const LinearProgressIndicator(
                  color: ColorManager.primaryColor,
                )
              : state is GetParamsSuccess
                  ? Padding(
                      padding: const EdgeInsetsDirectional.only(start: 0),
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: [
                          for (int i = 0; i < state.paramsList.length; i++)
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  end: 0, bottom: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  isUpdate == true
                                      ? CustomText(
                                          text: state.paramsList[i].title
                                              .toString(),
                                        )
                                      : const SizedBox(),
                                  Container(
                                    width: context.width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.buttonRadius),
                                        border: Border.all(
                                          color: ColorManager.borderColor,
                                        )),
                                    child: Center(
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: state.paramsList[i].type == 0
                                                ? SelectType(
                                                    isUpdate: isUpdate,
                                                    i: i,
                                                    paramsList:
                                                        state.paramsList,
                                                  )
                                                : state.paramsList[i].type == 2
                                                    ? TextNumberType(
                                                        isUpdate: isUpdate,
                                                        paramsList:
                                                            state.paramsList,
                                                        isNumber: false,
                                                        i: i,
                                                      )
                                                    : state.paramsList[i]
                                                                .type ==
                                                            4
                                                        ? TextNumberType(
                                                            isUpdate: isUpdate,
                                                            paramsList: state
                                                                .paramsList,
                                                            isNumber: true,
                                                            i: i,
                                                          )
                                                        : state.paramsList[i]
                                                                    .type ==
                                                                3
                                                            ? DateType(
                                                                paramsList: state
                                                                    .paramsList,
                                                                i: i,
                                                              )
                                                            : MultiSelectType(
                                                                isUpdate:
                                                                    isUpdate,
                                                                i: i,
                                                                paramsModel:
                                                                    state.paramsList[
                                                                        i]))),
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    )
                  : const SizedBox()),
    );
  }
}

class MaritalStatusDropdownButton extends StatefulWidget {
  final BuildContext context;

  MaritalStatusDropdownButton({super.key, required this.context});

  @override
  State<MaritalStatusDropdownButton> createState() =>
      _MaritalStatusDropdownButtonState();
}

class _MaritalStatusDropdownButtonState
    extends State<MaritalStatusDropdownButton> {
  final List<String> radioList = [
    //  Strings.enterMaritalStatus,
    Strings.single,
    Strings.married,
    Strings.heDivorced,
    Strings.sheDivorced,
    Strings.divorcedWithChildren,
    Strings.divorcedWithNoChildren,
    Strings.widower,
    Strings.others
  ];

  @override
  Widget build(BuildContext context) {
    int? selectedValue = SetUpBloc.get(context).setUpMap["MaritalStatus"];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      width: context.width,
      height: context.height * 0.08,
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorManager.borderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(Dimensions.buttonRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: DropdownButton<int>(
              value: selectedValue,
              underline: Container(
                color: Colors.transparent,
              ),
              items: [
                DropdownMenuItem<int>(
                  value: null,
                  child: Text(
                    Strings.enterMaritalStatus,
                    style: GoogleFonts.cairo(
                        textStyle: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
                ...List.generate(radioList.length, (index) {
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Text(
                      radioList[index],
                      style: GoogleFonts.cairo(
                          textStyle: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  );
                }),
              ],
              onChanged: (value) {
                SetUpBloc.get(context)
                    .changeMapValue(key: "MaritalStatus", value: value);
              },
              dropdownColor: Colors.white,
              style: const TextStyle(color: ColorManager.borderColor),
              iconEnabledColor: Colors.transparent,
            ),
          ),
          const Icon(Icons.keyboard_arrow_down,
              color: ColorManager.borderColor),
        ],
      ),
    );
  }
}

class ReligionDropdownButton extends StatefulWidget {
  final BuildContext context;
  final bool isUpdate;
  final bool isRequired;
  ReligionDropdownButton(
      {super.key,
      required this.context,
      this.isUpdate = false,
      this.isRequired = false});

  @override
  State<ReligionDropdownButton> createState() => _ReligionDropdownButtonState();
}

class _ReligionDropdownButtonState extends State<ReligionDropdownButton> {
  final List<String> radioList = [
    Strings.muslim,
    Strings.christian,
  ];

  int? selectedValue;
  @override
  void initState() {
    print('reliiiiigion updaaate');
    print(widget.isUpdate);
    if (widget.isRequired) {
      if (widget.isUpdate && ProfileBloc.get(context).partnerData != null) {
        selectedValue =
            ProfileBloc.get(context).partnerData!.religion == 'Muslim' ? 0 : 1;
        SetUpBloc.get(context).setUpMap["Religion"] = selectedValue;
      } else {
        selectedValue = SetUpBloc.get(context).setUpMap["Religion"];
      }
    } else {
      if (widget.isUpdate && ProfileBloc.get(context).profileData != null) {
        selectedValue =
            ProfileBloc.get(context).profileData!.religion == 'Muslim' ? 0 : 1;
      } else {
        selectedValue = SetUpBloc.get(context).setUpMap["Religion"];
        SetUpBloc.get(context).setUpMap["Religion"] = selectedValue;
      }
    }
    print(selectedValue);
    print(SetUpBloc.get(context).setUpMap['Religion']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SetUpBloc, SetUpStates>(
      listener: (BuildContext context, SetUpStates s) {},
      builder: (BuildContext context, SetUpStates s) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        width: context.width,
        height: context.height * 0.08,
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorManager.borderColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(Dimensions.buttonRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: DropdownButton<int>(
                value: SetUpBloc.get(context).setUpMap['Religion'],
                underline: Container(
                  color: Colors.transparent,
                ),
                items: [
                  if (widget.isUpdate == false)
                    DropdownMenuItem<int>(
                      value: null,
                      child: Text(
                        Strings.religion,
                        style: GoogleFonts.cairo(
                            textStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ...List.generate(radioList.length, (index) {
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Text(
                        radioList[index],
                        style: GoogleFonts.cairo(
                            textStyle: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                    );
                  }),
                ],
                onChanged: (value) {
                  print('drop religion value is ${value}');
                  SetUpBloc.get(context)
                      .changeMapValue(key: "Religion", value: value);
                  // setState(() {
                  //   selectedValue = value;
                  // });
                },
                dropdownColor: Colors.white,
                style: const TextStyle(color: ColorManager.borderColor),
                iconEnabledColor: Colors.transparent,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down,
                color: ColorManager.borderColor),
          ],
        ),
      ),
    );
  }
}
