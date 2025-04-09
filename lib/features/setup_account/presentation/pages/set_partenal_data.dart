import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
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
import '../widgets/age_selector.dart';

class SetPartnerData extends StatefulWidget {
  SetPartnerData({
    super.key,
    required this.isUpdated,
  });
  final bool isUpdated;
  @override
  State<SetPartnerData> createState() => _SetPartnerDataState();
}

class _SetPartnerDataState extends State<SetPartnerData> {
  @override
  void initState() {
    super.initState();

    if (widget.isUpdated) {
      ProfileBloc.get(context).getMyPartner();
      print('iaminit');
      log('iaminit${SetUpBloc.get(context).heightRange.start.toInt()}${SetUpBloc.get(context).heightRange.end.toInt()}');
    } else {
      SetUpBloc.get(context).defaultSetUpMap();
      SetUpBloc.get(context).multiSelectList = [];
      SetUpBloc.get(context).heightController.clear();
      SetUpBloc.get(context).weightController.clear();
      SetUpBloc.get(context).selectedDone = false;
      SetUpBloc.get(context)
          .fillSetupCollectList(ParamsBloc.get(context).paramsList);
    }
  }

  void initializeSetUpRequiredBody() async {
    await di.sl<ParamsBloc>().getParams(context);
    print('initializeSetUpRequiredBody');
    log(ProfileBloc.get(context).partnerData.toString());
    if (widget.isUpdated && ProfileBloc.get(context).partnerData != null) {
      print('isUpdated && ProfileBloc.get(context).partnerData != null');
      SetUpBloc bloc = SetUpBloc.get(context);
      SetupRequiredBody setupRequiredBody = SetupRequiredBody(
        maxHeight: ProfileBloc.get(context).partnerData!.maxHeight,
        maxWeight: ProfileBloc.get(context).partnerData!.maxWeight,
        minHeight: ProfileBloc.get(context).partnerData!.minHeight,
        minWeight: ProfileBloc.get(context).partnerData!.minWeight,
        searchGender:
            ProfileBloc.get(context).partnerData!.gender!.toLowerCase() ==
                    "male"
                ? 0
                : 1,
        maxAge: ProfileBloc.get(context).partnerData!.maxAge,
        minAge: ProfileBloc.get(context).partnerData!.minAge,
        selectionModel: [],
        isSmoking: ProfileBloc.get(context).partnerData!.isSmoking,
      );
      // SetUpBloc.get(context).minHeightRequiredController.text =
      //     setupRequiredBody.height.toString();
      // SetUpBloc.get(context).minWeightRequiredController.text =
      //     setupRequiredBody.weight.toString();
      bloc.setUpMap['IsSmoking'] = setupRequiredBody.isSmoking;
      bloc.setUpMap['SearchGender'] = setupRequiredBody.searchGender;
      bloc.selectedAgeRange = RangeValues(setupRequiredBody.minAge!.toDouble(),
          setupRequiredBody.maxAge!.toDouble());
      bloc.weightRange = RangeValues(setupRequiredBody.minWeight!.toDouble(),
          setupRequiredBody.maxWeight!.toDouble());
      bloc.heightRange = RangeValues(setupRequiredBody.minHeight!.toDouble(),
          setupRequiredBody.maxHeight!.toDouble());
      // SetUpBloc.get(context).fillSetupCollectList(ProfileBloc.get(context).partnerData!.parameters!,isUpdate: true);

      // SetUpBloc.get(context).dropValueBodyList=[];
      //SetUpBloc.get(context).textParams
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
      for (int i = 0;
          i < ProfileBloc.get(context).partnerData!.parameters!.length;
          i++) {
        print('iam in first for loop[$i]');
        print(
            ProfileBloc.get(context).partnerData!.parameters![i].parameterType);
        print(ProfileBloc.get(context)
                .partnerData!
                .parameters![i]
                .parameterType ==
            0);

        print(ProfileBloc.get(context).partnerData!.parameters);

        if (ProfileBloc.get(context)
                .partnerData!
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
                    'valueId===>${ProfileBloc.get(context).partnerData!.parameters![i].valueId}');
                print(
                    'isCheckedIndex===>${SetUpBloc.get(context).isChecked[i1]![i2]!.index}');

                if (SetUpBloc.get(context)
                        .isChecked[i1]![i2]!
                        .index
                        .toString() ==
                    ProfileBloc.get(context)
                        .partnerData!
                        .parameters![i]
                        .valueId
                        .toString()) {
                  SetUpBloc.get(context).isChecked[i1]![i2]!.value = true;
                  SetUpBloc.get(context).multiSelectList!.add(
                        ValueBody(
                          paramId: ProfileBloc.get(context)
                              .partnerData!
                              .parameters![i]
                              .parameterId,
                          value: ProfileBloc.get(context)
                              .partnerData!
                              .parameters![i]
                              .valueName,
                          valueId: ProfileBloc.get(context)
                              .partnerData!
                              .parameters![i]
                              .valueId,
                        ),
                      );

                  setState(() {});
                }
              }
            }
          }

          print(
              'len multiselect init =${SetUpBloc.get(context).multiSelectList!.length}');
        } else {
          for (int paramIndex = 0;
              paramIndex < ParamsBloc.get(context).paramsList.length;
              paramIndex++) {
            if (ParamsBloc.get(context).paramsList[paramIndex].id ==
                ProfileBloc.get(context)
                    .partnerData!
                    .parameters![i]
                    .parameterId) {
              SetUpBloc.get(context).changeDropList(
                  paramIndex,
                  Value(
                      value: ProfileBloc.get(context)
                          .partnerData!
                          .parameters![i]
                          .valueName,
                      id: ProfileBloc.get(context)
                          .partnerData!
                          .parameters![i]
                          .valueId),
                  ProfileBloc.get(context)
                      .partnerData!
                      .parameters![i]
                      .parameterId);
              //  break;
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SetUpBloc bloc = SetUpBloc.get(context);
    return BlocConsumer<ParamsBloc, SetUpStates>(
      listener: (context, state) {
        print(ProfileBloc.get(context).partnerData);
        if (state is GetParamsSuccess) {
          SetUpBloc.get(context).dropValueList =
              List.filled(state.paramsList.length, null);
          SetUpBloc.get(context).dropValueBodyList =
              List.filled(state.paramsList.length, null);
        }
      },
      builder: (context, state) => BlocConsumer<ProfileBloc, ProfileStates>(
        listener: (context, state) {
          log(ProfileBloc.get(context).partnerData.toString());
          if (state is SuccessPartner) {
            initializeSetUpRequiredBody();
          }
        },
        builder: (context, state) {
          print(ProfileBloc.get(context).partnerData);

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
                              state is LoadingProfile
                          //   ||ProfileBloc.get(context).partnerData == null
                          ? SizedBox(
                              height: Dimensions(context: context).buttonHeight,
                              child: const LoadingCircle())
                          : CustomButton(
                              onTap: () async {
                                List<ValueBody> list = [];

                                print(
                                    'len of value body List${SetUpBloc.get(context).multiSelectList!.length}');
                                for (int i = 0;
                                    i <
                                        SetUpBloc.get(context)
                                            .dropValueBodyList!
                                            .length;
                                    i++) {
                                  if (SetUpBloc.get(context)
                                          .dropValueBodyList![i] !=
                                      null) {
                                    print(
                                        'len of value body List111${SetUpBloc.get(context).dropValueBodyList!.length}');
                                    list.add(SetUpBloc.get(context)
                                        .dropValueBodyList![i]!);
                                  }
                                }
                                // for (var element
                                //     in SetUpBloc.get(context).multiSelectList!) {
                                //   list.add(element!);
                                // }
                                for (var element in SetUpBloc.get(context)
                                    .multiSelectList!) {
                                  print(
                                      'len of value body List222${SetUpBloc.get(context).multiSelectList!.length}');
                                  list.add(ValueBody(
                                    paramId: element?.paramId,
                                    valueId: element?.valueId,
                                    value: element?.value,
                                  ));
                                }

                                SetUpBloc.get(context).setUpMap.addEntries({
                                      "selectionModel": jsonEncode(list)
                                    }.entries);
                                SetUpBloc.get(context).setUpMap.addEntries({
                                      "selectionModel": jsonEncode(
                                          SetUpBloc.get(context)
                                              .multiSelectList)
                                    }.entries);

                                //     if (SetUpBloc.get(context)
                                //             .minHeightRequiredController
                                //             .text ==
                                //         '') {
                                //       context.getSnackBar(
                                //           snackText: 'You must add Height',
                                //           isError: true);
                                //     } else if (SetUpBloc.get(context)
                                //             .minWeightRequiredController
                                //             .text ==
                                //         '') {
                                //       context.getSnackBar(
                                //           snackText: 'You must add Weight',
                                //           isError: true);
                                //    } else
                                if (widget.isUpdated) {
                                  SetupRequiredBody setupRequiredBody =
                                      SetupRequiredBody(
                                          maxHeight: SetUpBloc.get(context)
                                              .heightRange
                                              .end
                                              .toInt(),
                                          maxWeight: SetUpBloc.get(context)
                                              .weightRange
                                              .end
                                              .toInt(),
                                          minHeight: SetUpBloc.get(context)
                                              .heightRange
                                              .start
                                              .toInt(),
                                          minWeight: SetUpBloc.get(context)
                                              .weightRange
                                              .start
                                              .toInt(),
                                          searchGender:
                                              bloc.setUpMap['SearchGender'],
                                          maxAge: SetUpBloc.get(context)
                                              .selectedAgeRange
                                              .end
                                              .toInt(),
                                          minAge: SetUpBloc.get(context)
                                              .selectedAgeRange
                                              .start
                                              .toInt(),
                                          selectionModel: list,
                                          isSmoking:
                                              bloc.setUpMap['IsSmoking']);
                                  debugPrint(
                                      'read body${setupRequiredBody.toJson()}');
                                  SetUpBloc.get(context).add(UpdatePertnerEvent(
                                      setupRequiredBody: setupRequiredBody));
                                } else {
                                  if (SetUpBloc.get(context)
                                          .setUpMap['Religion'] ==
                                      null) {
                                    context.getSnackBar(
                                        snackText: 'يجب إضافة الديانه',
                                        isError: true);
                                  } else {
                                    SetupRequiredBody setupRequiredBody =
                                        SetupRequiredBody(
                                            searchGender:
                                                bloc.setUpMap['SearchGender'],
                                            maxAge: SetUpBloc.get(context)
                                                .selectedAgeRange
                                                .end
                                                .toInt(),
                                            minAge: SetUpBloc.get(context)
                                                .selectedAgeRange
                                                .start
                                                .toInt(),
                                            selectionModel: list,
                                            maxHeight: SetUpBloc.get(context)
                                                .heightRange
                                                .end
                                                .toInt(),
                                            maxWeight: SetUpBloc.get(context)
                                                .weightRange
                                                .end
                                                .toInt(),
                                            minHeight: SetUpBloc.get(context)
                                                .heightRange
                                                .start
                                                .toInt(),
                                            minWeight: SetUpBloc.get(context)
                                                .weightRange
                                                .start
                                                .toInt(),
                                            isSmoking:
                                                bloc.setUpMap['IsSmoking']);
                                    SetUpBloc.get(context).add(
                                        PostSetUpRequiredEvent(
                                            setupRequiredBody));
                                    debugPrint(
                                        setupRequiredBody.toJson().toString());
                                  }
                                }
                              },
                              text: Strings.save,
                            ),
                    ),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomAppBar(
                              isBack: widget.isUpdated,
                              title: widget.isUpdated
                                  ? Strings.edit_required_data
                                  : 'مواصفات الشريك'),

                          //  AgeRangeSelector(),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: ListView(
                              children: [
                                // Column(
                                //   mainAxisAlignment: MainAxisAlignment.start,
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     const CustomText(
                                //       text: 'أضف مواصفات شريكك',
                                //       color: Colors.black,
                                //       fontSize: 15,
                                //       fontWeight: FontWeight.bold,
                                //     ),
                                //     SizedBox(
                                //       height: context.height * 0.015,
                                //     ),
                                //     const CustomText(
                                //       text:
                                //           '(يساعدنا على فرز الأشخاص المناسبين لك)',
                                //       color: Colors.black,
                                //       fontSize: 15,
                                //       fontWeight: FontWeight.normal,
                                //     ),
                                //   ],
                                // ),
                                const SizedBox(
                                  height: 15,
                                ),
                                // MaritalPartenalStatusDropdownButton(
                                //   context: context,
                                // ),

                                const Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [],
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
                                //         },
                                //         child: Container(
                                //             decoration: BoxDecoration(
                                //                 border: Border.all(
                                //                     width: 1.5,
                                //                     color: SetUpBloc.get(
                                //                                         context)
                                //                                     .setUpMap[
                                //                                 "SearchGender"] ==
                                //                             0
                                //                         ? ColorManager
                                //                             .primaryColor
                                //                         : Colors.grey)),
                                //             child: Padding(
                                //               padding: const EdgeInsets.all(5),
                                //               child: Image.asset(
                                //                   ImageManager.male),
                                //             ))),
                                //     SizedBox(
                                //       width: context.width * 0.2,
                                //     ),
                                //     InkWell(
                                //         onTap: () {
                                //           SetUpBloc.get(context).changeMapValue(
                                //               key: "SearchGender", value: 1);
                                //         },
                                //         child: Container(
                                //             decoration: BoxDecoration(
                                //                 border: Border.all(
                                //                     width: 1.5,
                                //                     color: SetUpBloc.get(
                                //                                         context)
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
                                const SizedBox(
                                  height: 15,
                                ),
                                AgeRangeSelector(),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const CustomText(
                                      text: Strings.height,
                                      color: ColorManager.borderColor,
                                    ),
                                    CustomText(
                                      text:
                                          '${SetUpBloc.get(context).heightRange.start.toInt()} - ${SetUpBloc.get(context).heightRange.end.toInt()}',
                                      color: ColorManager.darkGrey,
                                    ),
                                  ],
                                ),
                                RangeSlider(
                                  values: SetUpBloc.get(context).heightRange,
                                  onChanged: (RangeValues values) {
                                    SetUpBloc.get(context).changeAgeRangeValue(
                                        values,
                                        isHeight: true);
                                  },
                                  min: 0,
                                  max: 200,
                                  divisions: 73,
                                  activeColor: ColorManager.primaryColor,
                                  inactiveColor: ColorManager.borderColor,
                                  labels: RangeLabels(
                                    SetUpBloc.get(context)
                                        .heightRange
                                        .start
                                        .toInt()
                                        .toString(),
                                    SetUpBloc.get(context)
                                        .heightRange
                                        .end
                                        .toInt()
                                        .toString(),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const CustomText(
                                      text: Strings.weight,
                                      color: ColorManager.borderColor,
                                    ),
                                    CustomText(
                                      text:
                                          '${SetUpBloc.get(context).weightRange.start.toInt()} - ${SetUpBloc.get(context).weightRange.end.toInt()}',
                                      color: ColorManager.darkGrey,
                                    ),
                                  ],
                                ),
                                RangeSlider(
                                  values: SetUpBloc.get(context).weightRange,
                                  onChanged: (RangeValues values) {
                                    SetUpBloc.get(context).changeAgeRangeValue(
                                        values,
                                        isWeight: true);
                                  },
                                  min: 0,
                                  max: 200,
                                  divisions: 200,
                                  activeColor: ColorManager.primaryColor,
                                  inactiveColor: ColorManager.borderColor,
                                  labels: RangeLabels(
                                    SetUpBloc.get(context)
                                        .weightRange
                                        .start
                                        .toInt()
                                        .toString(),
                                    SetUpBloc.get(context)
                                        .weightRange
                                        .end
                                        .toInt()
                                        .toString(),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                // MainParam(
                                //   heightController:
                                //       bloc.minHeightRequiredController,
                                //   weightController:
                                //       bloc.minWeightRequiredController,
                                // ),
                                const SizedBox(
                                  height: 15,
                                ),

                                widget.isUpdated
                                    ? const SizedBox()
                                    : ReligionDropdownButton(
                                        isUpdate: false,
                                        context: context,
                                        isRequired: true,
                                      ),
                                const SizedBox(
                                  height: 15,
                                ),
                                ParamsBody(isUpdate: widget.isUpdated),
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

// class ParamsBody extends StatefulWidget {
//   const ParamsBody({super.key, required this.isUpdate});
//   final bool? isUpdate;
//   @override
//   State<ParamsBody> createState() => _ParamsBodyState();
// }
//
// class _ParamsBodyState extends State<ParamsBody> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<SetUpBloc, SetUpStates>(
//       listener: (BuildContext context, SetUpStates s) {},
//       builder: (BuildContext context, SetUpStates s) => BlocConsumer<ParamsBloc,
//               SetUpStates>(
//           listener: (BuildContext context, SetUpStates state) {
//             if (state is GetParamsSuccess) {
//               SetUpBloc.get(context).fillSetupCollectList(state.paramsList);
//             }
//           },
//           builder: (BuildContext context, SetUpStates state) => state
//                   is GetParamsLoading
//               ? const LinearProgressIndicator(
//                   color: ColorManager.primaryColor,
//                 )
//               : state is GetParamsSuccess
//                   ? Padding(
//                       padding: const EdgeInsetsDirectional.only(start: 10),
//                       child: Wrap(
//                         direction: Axis.horizontal,
//                         children: [
//                           for (int i = 0; i < state.paramsList.length; i++)
//                             Padding(
//                               padding: const EdgeInsetsDirectional.only(
//                                   end: 10, bottom: 15),
//                               child: Container(
//                                 width:
//                                     // state.paramsList[i].type == 0
//                                     //     ? (context.width * 0.5) - 45
//                                     //     :
//                                     (context.width) - 65,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(
//                                         Dimensions.buttonRadius),
//                                     border: Border.all(
//                                         color: ColorManager.borderColor)),
//                                 child: Center(
//                                     child: Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 20),
//                                         child: state.paramsList[i].type == 0
//                                             ? SelectType(
//                                                 i: i,
//                                                 paramsList: state.paramsList,
//                                               )
//                                             : state.paramsList[i].type == 2
//                                                 ? TextNumberType(
//                                                     paramsList:
//                                                         state.paramsList,
//                                                     isNumber: false,
//                                                     i: i,
//                                                   )
//                                                 : state.paramsList[i].type == 4
//                                                     ? TextNumberType(
//                                                         paramsList:
//                                                             state.paramsList,
//                                                         isNumber: true,
//                                                         i: i,
//                                                       )
//                                                     : state.paramsList[i]
//                                                                 .type ==
//                                                             3
//                                                         ? DateType(
//                                                             paramsList: state
//                                                                 .paramsList,
//                                                             i: i,
//                                                           )
//                                                         : MultiSelectType(
//                                                             i: i,
//                                                             paramsModel: state
//                                                                     .paramsList[
//                                                                 i]))),
//                               ),
//                             )
//                         ],
//                       ),
//                     )
//                   : const SizedBox()),
//     );
//   }
// }

class MaritalPartenalStatusDropdownButton extends StatelessWidget {
  final BuildContext context;

  MaritalPartenalStatusDropdownButton({super.key, required this.context});

  final List<String> radioList = [
    'الحالة الاجتماعية',
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
                // DropdownMenuItem<int>(
                //   value: null,
                //   child: Text(
                //     Strings.enterMaritalStatus,
                //     style: GoogleFonts.cairo(
                //         textStyle: const TextStyle(
                //             fontSize: 15, fontWeight: FontWeight.bold)),
                //   ),
                // ),
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
                // SetUpBloc.get(context)
                //     .changeMapValue(key: "MaritalStatus", value: value);
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
