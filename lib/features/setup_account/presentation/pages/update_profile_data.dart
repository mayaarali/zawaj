// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/loading_circle.dart';
import 'package:zawaj/features/dashboard/view.dart';
import 'package:zawaj/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:zawaj/features/profile/presentation/bloc/states.dart';
import 'package:zawaj/features/setup_account/data/models/params_model.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/event.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/params_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/pages/set_personal_data.dart';
import 'package:zawaj/injection_controller.dart' as di;

import '../../../../core/constants/strings.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../data/models/setup_required_body.dart';
import '../bloc/setup_bloc.dart';
import '../bloc/states.dart';
import '../widgets/main_params.dart';

class UpdateProfileData extends StatefulWidget {
  UpdateProfileData({
    Key? key,
    this.isUpdate,
  }) : super(key: key);
  final bool? isUpdate;
  @override
  State<UpdateProfileData> createState() => _UpdateProfileDataState();
}

class _UpdateProfileDataState extends State<UpdateProfileData> {
  @override
  void initState() {
    di.sl<ParamsBloc>().getParams(context);
    ProfileBloc.get(context).getMyProfile();
    ParamsBloc.get(context).getParams(context);

    super.initState();
  }

  int getBirthYearFromAge(int age) {
    DateTime now = DateTime.now();
    int currentYear = now.year;
    int birthYear = currentYear - age;
    return birthYear;
  }

  void initializeSetUpProfileBody() {
    print('initializeSetUpRequiredBody');
    log(ParamsBloc.get(context).paramsList.length.toString());
    log(ProfileBloc.get(context).profileData.toString());

    if (ProfileBloc.get(context).profileData != null) {
      print('isUpdated && ProfileBloc.get(context).profileData != null');
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
      SetUpBloc.get(context).heightController.text =
          '${ProfileBloc.get(context).profileData!.height ?? '0'}';

      SetUpBloc.get(context).weightController.text =
          '${ProfileBloc.get(context).profileData!.weight ?? '0'}';
      SetUpBloc.get(context).controllerName.text =
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
        "Height": null,
        "Weight": null,
        "IsSmoking": setupRequiredBody.isSmoking,
        "MaxAge": 0,
        "MinAge": 0,
      };
      print(
          '//////////////////////////////////////////////////////////////////////////////');
      if (ParamsBloc.get(context).paramsList.isNotEmpty) {
        SetUpBloc.get(context).dropValueList =
            List.filled(ParamsBloc.get(context).paramsList.length, null);
        SetUpBloc.get(context).dropValueBodyList =
            List.filled(ParamsBloc.get(context).paramsList.length, null);
        SetUpBloc.get(context).isChecked =
            List.filled(ParamsBloc.get(context).paramsList.length, null);
      }
      for (int i = 0; i < ParamsBloc.get(context).paramsList.length; i++) {
        if (ParamsBloc.get(context).paramsList[i].type == 1) {
          SetUpBloc.get(context).isChecked[i] = List.filled(
              ParamsBloc.get(context).paramsList[i].values!.length, null);

          for (int i2 = 0;
              i2 < ParamsBloc.get(context).paramsList[i].values!.length;
              i2++) {
            // isChecked[i]!.add(Checked(value:false ,index:element.id));

            SetUpBloc.get(context).isChecked[i]![i2] = Checked(
                value: false,
                index: ParamsBloc.get(context).paramsList[i].values![i2].id);
          }

          SetUpBloc.get(context).isChecked[i]!.forEach((element) {
            print('in blooooc len1 is ==>${element!.value} ${element!.index}');
          });
        }
      }
      SetUpBloc.get(context).multiSelectList = [];
      print('BEEEEEEEEEEEEFOOOOOOOOOOREEEEEEEEEEEE');
      debugPrint(
          "text item update is ${SetUpBloc.get(context).dropValueList!}");
      debugPrint(
          "text item update is ${SetUpBloc.get(context).dropValueBodyList!}");
      debugPrint(
          "text item update is ${SetUpBloc.get(context).multiSelectList!}");
      for (int i = 0;
          i < ProfileBloc.get(context).profileData!.parameters!.length;
          i++) {
        //case 1 multi select
        if (ProfileBloc.get(context)
                .profileData!
                .parameters![i]
                .parameterType ==
            1) {
          for (int i1 = 0; i1 < SetUpBloc.get(context).isChecked.length; i1++) {
            if (SetUpBloc.get(context).isChecked[i1] != null) {
              print("checked not null");
              print(SetUpBloc.get(context).isChecked[i1]!);

              for (int i2 = 0;
                  i2 < SetUpBloc.get(context).isChecked[i1]!.length;
                  i2++) {
                print(
                    'valueId===>${ProfileBloc.get(context).profileData!.parameters![i].valueId}');
                print(
                    'isCheckedIndex===>${SetUpBloc.get(context).isChecked[i1]![i2]!.index}');

                if (SetUpBloc.get(context)
                        .isChecked[i1]![i2]!
                        .index
                        .toString() ==
                    ProfileBloc.get(context)
                        .profileData!
                        .parameters![i]
                        .valueId
                        .toString()) {
                  print('iam innnn');
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

          print(
              'len multiselect init =${SetUpBloc.get(context).multiSelectList!.length}');
        } else {
          for (int paramIndex = 0;
              paramIndex < ParamsBloc.get(context).paramsList.length;
              paramIndex++) {
            if (ParamsBloc.get(context).paramsList[paramIndex].id ==
                ProfileBloc.get(context)
                    .profileData!
                    .parameters![i]
                    .parameterId) {
              SetUpBloc.get(context).changeDropList(
                  paramIndex,
                  Value(
                      value: ProfileBloc.get(context)
                          .profileData!
                          .parameters![i]
                          .valueName,
                      id: ProfileBloc.get(context)
                          .profileData!
                          .parameters![i]
                          .valueId),
                  ProfileBloc.get(context)
                      .profileData!
                      .parameters![i]
                      .parameterId);
              //  break;
            }
          }
        }

        //
        //         if (ProfileBloc.get(context)
        //               .profileData!
        //               .parameters![i]
        //               .parameterType ==
        //           0) {
        //         ///case 0
        //         ///
        //         if (ParamsBloc.get(context).paramsList[i].id ==
        //             ProfileBloc.get(context)
        //                 .profileData!
        //                 .parameters![i]
        //                 .parameterId) {
        //           SetUpBloc.get(context).changeDropList(
        //               i,
        //               Value(
        //                   value: ProfileBloc.get(context)
        //                       .profileData!
        //                       .parameters![i]
        //                       .valueName,
        //                   id: ProfileBloc.get(context)
        //                       .profileData!
        //                       .parameters![i]
        //                       .valueId),
        //               ProfileBloc.get(context).profileData!.parameters![i].parameterId);
        //         }
        //
        //       } else {
        //         print('parameter type not equal 0||1');
        //         print(i);
        //
        //
        //         SetUpBloc.get(context).changeDropList(
        //             i,
        //             Value(
        //                 value: ProfileBloc.get(context)
        //                     .profileData!
        //                     .parameters![i]
        //                     .valueName,
        //                 id: ProfileBloc.get(context)
        //                     .profileData!
        //                     .parameters![i]
        //                     .valueId),
        //             ProfileBloc.get(context).profileData!.parameters![i].parameterId);
        //         debugPrint(
        //             "text item update is ${SetUpBloc.get(context).dropValueList![i]}");
        //
        //         // SetUpBloc.get(context).textParams[i] =
        //         //     ProfileBloc.get(context).profileData!.parameters![i].valueName.toString();
        //         // print(SetUpBloc.get(context).textParams[i]);
        //       }
      }
    }
    print('000000000000000000000000');
    debugPrint("text item update is ${SetUpBloc.get(context).dropValueList!}");
    debugPrint(
        "text item update is ${SetUpBloc.get(context).dropValueBodyList!}");
    debugPrint(
        "text item update is ${SetUpBloc.get(context).multiSelectList!}");
  }

  @override
  Widget build(BuildContext context) {
    SetUpBloc bloc = SetUpBloc.get(context);
    return BlocConsumer<ParamsBloc, SetUpStates>(
      listener: (context, state) {
        print(ProfileBloc.get(context).profileData);
        if (state is GetParamsSuccess) {
          // SetUpBloc.get(context).dropValueList =
          //     List.filled(state.paramsList.length, null);
          // SetUpBloc.get(context).dropValueBodyList =
          //     List.filled(state.paramsList.length, null);
          initializeSetUpProfileBody();
        }
      },
      builder: (context, state) => BlocConsumer<ProfileBloc, ProfileStates>(
        listener: (context, state) {
          log(ProfileBloc.get(context).profileData.toString());
          if (state is SuccessProfile) {
            initializeSetUpProfileBody();
          }
        },
        builder: (context, state) {
          log(ProfileBloc.get(context).profileData.toString());
          return BlocConsumer<SetUpBloc, SetUpStates>(
            listener: (BuildContext context, SetUpStates state) {
              if (state is SuccessRequiredSetUp) {
                MagicRouter.navigateAndPopAll(const DashBoardScreen(
                  initialIndex: 2,
                ));
              }
              if (state is FailedRequiredSetUp) {
                context.getSnackBar(snackText: state.message, isError: true);
              }
            },
            builder: (BuildContext context, SetUpStates state) =>
                CustomScaffold(
                    isFullScreen: true,
                    bottomNavigationBar: Padding(
                      padding: const EdgeInsets.all(Dimensions.defaultPadding),
                      child: state is LoadingRequiredSetUp ||
                              state is LoadingProfile ||
                              ProfileBloc.get(context).profileData == null
                          ? SizedBox(
                              height: Dimensions(context: context).buttonHeight,
                              child: const LoadingCircle())
                          : CustomButton(
                              onTap: () async {
                                if (SetUpBloc.get(context)
                                    .heightController
                                    .text
                                    .isEmpty) {
                                  context.getSnackBar(
                                      snackText: 'يجب إضافة طولك',
                                      isError: true);
                                } else if ((double.tryParse(SetUpBloc.get(context)
                                                .heightController
                                                .text) ??
                                            0) >
                                        200 ||
                                    (double.tryParse(SetUpBloc.get(context)
                                                .heightController
                                                .text) ??
                                            0) <
                                        0) {
                                  context.getSnackBar(
                                      snackText:
                                          'الطول غير صحيح. اقصي طول [200-0]',
                                      isError: true);
                                } else if (((double.tryParse(
                                                SetUpBloc.get(context)
                                                    .weightController
                                                    .text) ??
                                            0) >
                                        200 ||
                                    (double.tryParse(SetUpBloc.get(context)
                                                .weightController
                                                .text) ??
                                            0) <
                                        0)) {
                                  context.getSnackBar(
                                      snackText:
                                          'الوزن غير صحيح. اقصي وزن [200-0]',
                                      isError: true);
                                } else if (SetUpBloc.get(context).weightController.text.isEmpty) {
                                  context.getSnackBar(
                                      snackText: 'يجب إضافة وزنك',
                                      isError: true);
                                } else {
                                  await SetUpBloc.get(context).changeMapValue(
                                      key: "Height",
                                      value: double.tryParse(
                                              SetUpBloc.get(context)
                                                  .heightController
                                                  .text) ??
                                          0);
                                  await SetUpBloc.get(context).changeMapValue(
                                      key: "Weight",
                                      value: double.tryParse(
                                              SetUpBloc.get(context)
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
                                  for (var element in SetUpBloc.get(context)
                                      .multiSelectList!) {
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
                                      SetUpBloc.get(context)
                                          .setUpMap
                                          .addEntries({
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

                                  log(SetUpBloc.get(context)
                                      .setUpMap
                                      .toString());

                                  log("setup body ${SetUpBloc.get(context).setUpMap}");
                                  SetUpBloc.get(context)
                                      .add(UpdateSetUpEvent());
                                }
                              },
                              text: Strings.saveChnages,
                            ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        print('Unfocus************************');
                        FocusScope.of(context).unfocus();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const CustomAppBar(
                            title: 'مواصفاتي الشخصية',
                          ),

                          //  AgeRangeSelector(),

                          Expanded(
                            child: ListView(
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.center,
                                    //   children: [
                                    //     InkWell(
                                    //         onTap: () {
                                    //           SetUpBloc.get(context)
                                    //               .changeMapValue(
                                    //                   key: "Gender", value: 0);
                                    //           SetUpBloc.get(context)
                                    //               .changeMapValue(
                                    //                   key: "SearchGender",
                                    //                   value: 1);
                                    //         },
                                    //         child: Container(
                                    //             decoration: BoxDecoration(
                                    //                 borderRadius:
                                    //                     BorderRadius.circular(8),
                                    //                 border: Border.all(
                                    //                     color: SetUpBloc.get(
                                    //                                         context)
                                    //                                     .setUpMap[
                                    //                                 "Gender"] ==
                                    //                             0
                                    //                         ? ColorManager
                                    //                             .primaryColor
                                    //                         : Colors.grey)),
                                    //             child: Padding(
                                    //               padding:
                                    //                   const EdgeInsets.all(5),
                                    //               child: Image.asset(
                                    //                   ImageManager.male),
                                    //             ))),
                                    //     SizedBox(
                                    //       width: context.width * 0.2,
                                    //     ),
                                    //     InkWell(
                                    //         onTap: () {
                                    //           SetUpBloc.get(context)
                                    //               .changeMapValue(
                                    //                   key: "Gender", value: 1);
                                    //           SetUpBloc.get(context)
                                    //               .changeMapValue(
                                    //                   key: "SearchGender",
                                    //                   value: 0);
                                    //         },
                                    //         child: Container(
                                    //             decoration: BoxDecoration(
                                    //                 borderRadius:
                                    //                     BorderRadius.circular(8),
                                    //                 border: Border.all(
                                    //                     color: SetUpBloc.get(
                                    //                                         context)
                                    //                                     .setUpMap[
                                    //                                 "Gender"] ==
                                    //                             1
                                    //                         ? ColorManager
                                    //                             .primaryColor
                                    //                         : Colors.grey)),
                                    //             child: Padding(
                                    //               padding:
                                    //                   const EdgeInsets.all(5),
                                    //               child: Image.asset(
                                    //                   ImageManager.female),
                                    //             ))),
                                    //   ],
                                    // ),
                                    // SizedBox(
                                    //   height: context.height * 0.03,
                                    // ),
                                    // CustomText(
                                    //   text: Strings.search_for,
                                    //   fontWeight: FontWeight.normal,
                                    // ),
                                  ],
                                ),
                                // SizedBox(
                                //   height: context.height * 0.03,
                                // ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     InkWell(
                                //         onTap: () {
                                //           SetUpBloc.get(context).changeMapValue(
                                //               key: "SearchGender", value: 0);
                                //           SetUpBloc.get(context).changeMapValue(
                                //               key: "Gender", value: 1);
                                //         },
                                //         child: Container(
                                //             decoration: BoxDecoration(
                                //                 borderRadius:
                                //                     BorderRadius.circular(8),
                                //                 border: Border.all(
                                //                     color: SetUpBloc.get(context)
                                //                                     .setUpMap[
                                //                                 "SearchGender"] ==
                                //                             0
                                //                         ? ColorManager
                                //                             .primaryColor
                                //                         : Colors.grey)),
                                //             child: Padding(
                                //               padding: const EdgeInsets.all(5),
                                //               child:
                                //                   Image.asset(ImageManager.male),
                                //             ))),
                                //     SizedBox(
                                //       width: context.width * 0.2,
                                //     ),
                                //     InkWell(
                                //         onTap: () {
                                //           //  // if (SetUpBloc.get(context).setUpMap["Gender"] == 0) {
                                //           //     SetUpBloc.get(context)
                                //           //         .changeMapValue(key: "SearchGender", value: 1);
                                //           //   //} else {
                                //           //     SetUpBloc.get(context)
                                //           //         .changeMapValue(key: "SearchGender", value: 0);
                                //           //   //}
                                //           SetUpBloc.get(context).changeMapValue(
                                //               key: "SearchGender", value: 1);
                                //           SetUpBloc.get(context).changeMapValue(
                                //               key: "Gender", value: 0);
                                //         },
                                //         child: Container(
                                //             decoration: BoxDecoration(
                                //                 borderRadius:
                                //                     BorderRadius.circular(8),
                                //                 border: Border.all(
                                //                     color: SetUpBloc.get(context)
                                //                                     .setUpMap[
                                //                                 "SearchGender"] ==
                                //                             1
                                //                         ? ColorManager
                                //                             .primaryColor
                                //                         : Colors.grey)),
                                //             child: Padding(
                                //               padding: const EdgeInsets.all(5),
                                //               child: Image.asset(
                                //                   ImageManager.female),
                                //             ))),
                                //   ],
                                // ),

                                MainParam(
                                  isUpdate: widget.isUpdate,
                                  heightController: bloc.heightController,
                                  weightController: bloc.weightController,
                                ),
                                // const Padding(
                                //   padding: EdgeInsets.symmetric(horizontal: 10),
                                //   child: CustomCityDropDown(
                                //     isUpdate: true,
                                //   ),
                                // ),
                                // const Padding(
                                //   padding: EdgeInsets.symmetric(horizontal: 10),
                                //   child: CustomAreaDropDown(
                                //     isUpdate: true,
                                //   ),
                                // ),
                                const SizedBox(
                                  height: 15,
                                ),
                                ParamsBody(
                                  isUpdate: widget.isUpdate,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
          );
        },
      ),
    );
  }
}
