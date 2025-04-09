import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/custom_appbar.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/core/widgets/loading_circle.dart';
import 'package:zawaj/features/dashboard/view.dart';
import 'package:zawaj/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:zawaj/features/profile/presentation/bloc/states.dart';
import 'package:zawaj/features/setup_account/data/models/params_model.dart';
import 'package:zawaj/features/setup_account/data/models/setup_required_body.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/area_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/city_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/event.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/params_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/setup_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/states.dart';
import 'package:zawaj/features/setup_account/presentation/pages/age_screen.dart';
import 'package:zawaj/features/setup_account/presentation/widgets/custom_expandable_panel.dart';
import 'package:zawaj/injection_controller.dart' as di;

class AgeAndPlaceOfBirteScreen extends StatefulWidget {
  AgeAndPlaceOfBirteScreen(
      {super.key,
      required this.age,
      required this.area,
      required this.country});
  final int age;
  final String area;
  final String country;

  @override
  State<AgeAndPlaceOfBirteScreen> createState() =>
      _AgeAndPlaceOfBirteScreenState();
}

class _AgeAndPlaceOfBirteScreenState extends State<AgeAndPlaceOfBirteScreen> {
  final TextEditingController editAgeController = TextEditingController();

  final TextEditingController editAreaController = TextEditingController();

  final TextEditingController editCountryController = TextEditingController();
  @override
  void initState() {
    super.initState();
    di.sl<ParamsBloc>().getParams(context);
    ParamsBloc.get(context).getParams(context);

    ProfileBloc.get(context).getMyProfile();

    //initializeSetUpProfileBody();
  }

  void initializeSetUpProfileBody() {
    log('initializeSetUpRequiredBody');
    log(ProfileBloc.get(context).profileData.toString());
    if (ProfileBloc.get(context).profileData != null) {
      log('isUpdated && ProfileBloc.get(context).profileData != null');
      SetUpBloc bloc = SetUpBloc.get(context);
      SetupRequiredBody setupRequiredBody = SetupRequiredBody(
        maxHeight: SetUpBloc.get(context).heightRange.end.toInt(),
        maxWeight: SetUpBloc.get(context).weightRange.end.toInt(),
        minHeight: SetUpBloc.get(context).heightRange.start.toInt(),
        minWeight: SetUpBloc.get(context).weightRange.start.toInt(),
        searchGender:
            ProfileBloc.get(context).profileData!.gender!.toLowerCase() ==
                    "male"
                ? 1
                : 0,
        selectionModel: [],
        isSmoking: ProfileBloc.get(context).profileData!.isSmoking,
        maxAge: null,
        minAge: null,
      );
      // SetUpBloc.get(context).heightController.text =
      //     setupRequiredBody.height.toString();
      // SetUpBloc.get(context).weightController.text =
      //     setupRequiredBody.weight.toString();
      // SetUpBloc.get(context).controllerName.text =
      ProfileBloc.get(context).profileData!.name ?? '';
      SetUpBloc.get(context).setUpMap = {
        "Gender": setupRequiredBody.searchGender == 0 ? 1 : 0,
        "SearchGender": setupRequiredBody.searchGender,
        "Name": ProfileBloc.get(context).profileData!.name ?? '',
        "BirthDay": ProfileBloc.get(context).profileData!.birthDay,
        //   getBirthYearFromAge(ProfileBloc.get(context).profileData!.age ?? 0),
        "MaritalStatus": ProfileBloc.get(context).profileData!.maritalStatusId,
        "CityId": ProfileBloc.get(context).profileData!.cityId,
        "AreaId": ProfileBloc.get(context).profileData!.areaId,
        "Height": 15,
        "Weight": 15,
        "IsSmoking": setupRequiredBody.isSmoking,
        "MaxAge": 0,
        "MinAge": 0,
      };
      SetUpBloc.get(context).multiSelectList = [];
      for (int i = 0;
          i < ProfileBloc.get(context).profileData!.parameters!.length;
          i++) {
        if (ProfileBloc.get(context)
                .profileData!
                .parameters![i]
                .parameterType ==
            1) {
          for (int i1 = 0; i1 < SetUpBloc.get(context).isChecked.length; i1++) {
            if (SetUpBloc.get(context).isChecked[i1] != null) {
              log("checked not null");
              log(SetUpBloc.get(context).isChecked[i1]!.toString());

              for (int i2 = 0;
                  i2 < SetUpBloc.get(context).isChecked[i1]!.length;
                  i2++) {
                log('valueId===>${ProfileBloc.get(context).profileData!.parameters![i].valueId}');
                log('isCheckedIndex===>${SetUpBloc.get(context).isChecked[i1]![i2]!.index}');

                if (SetUpBloc.get(context)
                        .isChecked[i1]![i2]!
                        .index
                        .toString() ==
                    ProfileBloc.get(context)
                        .profileData!
                        .parameters![i]
                        .valueId
                        .toString()) {
                  log('iam innnn');
                  SetUpBloc.get(context).isChecked[i1]![i2]!.value = true;
                  setState(() {});
                }
              }
            }
          }
          SetUpBloc.get(context).multiSelectList!.add(
                ValueBody(
                  paramId: ProfileBloc.get(context)
                      .profileData!
                      .parameters![i]
                      .parameterId,
                  value: ProfileBloc.get(context)
                      .profileData!
                      .parameters![i]
                      .valueName,
                  valueId: ProfileBloc.get(context)
                      .profileData!
                      .parameters![i]
                      .valueId,
                ),
              );

          log('len multiselect init =${SetUpBloc.get(context).multiSelectList!.length}');
        } else if (ProfileBloc.get(context)
                .profileData!
                .parameters![i]
                .parameterType ==
            0) {
          SetUpBloc.get(context).changeDropList(
              i,
              Value(
                  value: ProfileBloc.get(context)
                      .profileData!
                      .parameters![i]
                      .valueName,
                  id: ProfileBloc.get(context)
                      .profileData!
                      .parameters![i]
                      .valueId),
              ProfileBloc.get(context).profileData!.parameters![i].parameterId);
        } else {
          log('parameter type not equal 0||1');
          SetUpBloc.get(context).changeDropList(
              i,
              Value(
                  value: ProfileBloc.get(context)
                      .profileData!
                      .parameters![i]
                      .valueName,
                  id: ProfileBloc.get(context)
                      .profileData!
                      .parameters![i]
                      .valueId),
              ProfileBloc.get(context).profileData!.parameters![i].parameterId);
          log("text item update is ${SetUpBloc.get(context).dropValueList![i]}");

          SetUpBloc.get(context).textParams[i] = ProfileBloc.get(context)
              .profileData!
              .parameters![i]
              .valueName
              .toString();
          log(SetUpBloc.get(context).textParams[i].toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParamsBloc, SetUpStates>(
      listener: (context, state) {
        log(ProfileBloc.get(context).profileData.toString());
        if (state is GetParamsSuccess) {}
      },
      builder: (context, state) {
        return BlocConsumer<ProfileBloc, ProfileStates>(
          listener: (context, state) {
            log(ProfileBloc.get(context).profileData.toString());
            if (state is SuccessProfile) {
              initializeSetUpProfileBody();
            }
          },
          builder: (context, state) {
            return BlocConsumer<SetUpBloc, SetUpStates>(
              listener: (context, state) {
                if (state is SuccessRequiredSetUp) {
                  // initializeSetUpProfileBody();

                  MagicRouter.navigateAndPopAll(const DashBoardScreen(
                    initialIndex: 2,
                  ));
                }
                if (state is FailedRequiredSetUp) {
                  context.getSnackBar(snackText: state.message, isError: true);
                }
              },
              builder: (context, state) {
                return CustomScaffold(
                  bottomNavigationBar: Padding(
                    padding: const EdgeInsets.all(Dimensions.defaultPadding),
                    child: state is LoadingRequiredSetUp
                        ? SizedBox(
                            height: Dimensions(context: context).buttonHeight,
                            child: const LoadingCircle())
                        : CustomButton(
                            onTap: () async {
                              await SetUpBloc.get(context).changeMapValue(
                                  key: "Height",
                                  value: double.tryParse(SetUpBloc.get(context)
                                          .heightController
                                          .text) ??
                                      0);
                              await SetUpBloc.get(context).changeMapValue(
                                  key: "Weight",
                                  value: double.tryParse(SetUpBloc.get(context)
                                          .weightController
                                          .text) ??
                                      0);

                              List<ValueBody?> list = [];
                              for (int i = 0;
                                  i <
                                      SetUpBloc.get(context)
                                          .dropValueBodyList!
                                          .length;
                                  i++) {
                                if (SetUpBloc.get(context)
                                        .dropValueBodyList![i] !=
                                    null) {
                                  list.add(SetUpBloc.get(context)
                                      .dropValueBodyList![i]);
                                }
                              }
                              for (var element
                                  in SetUpBloc.get(context).multiSelectList!) {
                                list.add(element);
                              }
                              if (ProfileBloc.get(context)
                                      .profileData!
                                      .images !=
                                  null) {
                                for (var i = 0;
                                    i <
                                        ProfileBloc.get(context)
                                            .profileData!
                                            .images!
                                            .length;
                                    i++) {
                                  SetUpBloc.get(context).setUpMap.addEntries({
                                        "ExistImagesPath[$i]":
                                            ProfileBloc.get(context)
                                                .profileData!
                                                .images![i]
                                      }.entries);
                                }
                              }

                              SetUpBloc.get(context).setUpMap.addEntries({
                                    "selectionModel": List<dynamic>.from(
                                        list.map((x) => x!.toJson()))
                                  }.entries);

                              log(SetUpBloc.get(context).setUpMap.toString());

                              log("setup body ${SetUpBloc.get(context).setUpMap}");
                              SetUpBloc.get(context).add(UpdateSetUpEvent());
                            },
                            text: Strings.saveChnages,
                          ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomAppBar(
                          isBack: true,
                          title: 'العمر ومكان الميلاد',
                        ),
                        const CustomText(text: 'العمر'),
                        const SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                          onTap: () async {
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              confirmText: 'حسنآ',
                              cancelText: 'الغاء',
                              helpText: 'تحديد التاريخ',
                              barrierLabel: 'أدخل التاريخ',
                              fieldLabelText: 'أدخل التاريخ',
                              errorFormatText: 'تنسيق التاريخ غير صالح',
                              errorInvalidText: 'تاريخ غير صالح',
                              builder: (context, child) {
                                return Theme(
                                    data: Theme.of(context).copyWith(
                                        textTheme: const TextTheme(
                                      bodyLarge: TextStyle(
                                          fontSize: 15.0, color: Colors.black),
                                      headlineLarge: TextStyle(fontSize: 30.0),
                                    )),
                                    child: child!);
                              },
                              locale: const Locale('ar'),
                              initialEntryMode:
                                  DatePickerEntryMode.calendarOnly,
                              initialDate: DateTime(DateTime.now().year - 18,
                                  DateTime.now().month, DateTime.now().day),
                              firstDate: DateTime(1950),
                              lastDate: DateTime(DateTime.now().year - 18,
                                  DateTime.now().month, DateTime.now().day),
                            );
                            if (selectedDate != null) {
                              int newAge =
                                  DateTime.now().year - selectedDate.year;
                              if (DateTime.now().month < selectedDate.month ||
                                  (DateTime.now().month == selectedDate.month &&
                                      DateTime.now().day < selectedDate.day)) {
                                newAge--;
                              }
                              SetUpBloc.get(context).changeMapValue(
                                  key: "BirthDay",
                                  value: selectedDate.toString());
                              editAgeController.text = newAge.toString();
                            }
                          },
                          child: AbsorbPointer(
                            absorbing: true,
                            child: CustomExpandedPanel(
                              isUpdate: true,
                              header: CustomText(
                                text: editAgeController.text.isEmpty
                                    ? widget.age.toString()
                                    : editAgeController.text,
                                // age.toString(),
                                color: ColorManager.borderColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              expanded: const SizedBox(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const CustomText(text: 'مكان الاقامة'),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: CustomCityDropDown(
                                isUpdate: true,
                              ),
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Expanded(
                              child: CustomAreaDropDown(
                                isUpdate: true,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
