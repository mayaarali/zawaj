// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:zawaj/features/setup_account/data/models/area_model.dart';
import 'package:zawaj/features/setup_account/data/models/city_model.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/area_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/city_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/event.dart';
import 'package:zawaj/features/setup_account/presentation/pages/marital_screen.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_scaffold.dart';
import '../../../../core/widgets/custom_text.dart';
import '../bloc/setup_bloc.dart';
import '../bloc/states.dart';
import '../widgets/custom_radios.dart';

class AgeScreen extends StatelessWidget {
  const AgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isFullScreen: true,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CustomAppBar(
              title: Strings.some_information_about,
              isBack: true,
            ),
            const CustomRadios(2),
            SizedBox(
              height: context.height * 0.09,
            ),
            const Row(
              children: [
                CustomText(
                  text: Strings.birthyear,
                  fontWeight: FontWeight.normal,
                ),
                SizedBox(
                  width: 20,
                ),
                YearDropdownWidget()
                //Expanded(child: BirthYearList())
              ],
            ),
            SizedBox(
              height: context.height * 0.06,
            ),
            const Align(
              alignment: Alignment.topRight,
              child: CustomText(
                text: Strings.whereFrom,
              ),
            ),
            const CustomCityDropDown(),
            CustomAreaDropDown(),
            const SizedBox(
              height: 12,
            ),
            CustomButton(
              text: Strings.next,
              onTap: () {
                if (SetUpBloc.get(context).setUpMap["BirthDay"] == null) {
                  context.getSnackBar(
                      snackText: 'يجب إضافة تاريخ ميلادك', isError: true);
                } else if (SetUpBloc.get(context).setUpMap["CityId"] == null) {
                  context.getSnackBar(
                      snackText: 'يجب إضافة مدينتك', isError: true);
                } else if (SetUpBloc.get(context).setUpMap["AreaId"] == null) {
                  context.getSnackBar(
                      snackText: 'يجب إضافة منطقتك', isError: true);
                } else {
                  MagicRouter.navigateTo(MaritalStatus());
                }
                //SetUpBloc.get(context).changeMapValue(key:"BirthYear" ,value:SetUpBloc.get(context).controllerName.text );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class YearDropdownWidget extends StatefulWidget {
  const YearDropdownWidget({super.key});

  @override
  _YearDropdownWidgetState createState() => _YearDropdownWidgetState();
}

class _YearDropdownWidgetState extends State<YearDropdownWidget> {
  @override
  Widget build(BuildContext context) {
    //   var formattedDate = SetUpBloc.get(context).selectedDate;
    return BlocConsumer<SetUpBloc, SetUpStates>(
      listener: (BuildContext context, SetUpStates state) {},
      builder: (BuildContext context, SetUpStates state) => GestureDetector(
        onTap: () {
          SetUpBloc.get(context).selectDatee(context);
        },
        child: Container(
            height: Dimensions(context: context).textFieldHeight,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(Dimensions.buttonRadius)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                    color: Colors.grey,
                    text: SetUpBloc.get(context).selectedDone
                        ? DateFormat('dd/MM/yyyy')
                            .format(SetUpBloc.get(context).selectedDate)
                        : Strings.birth_date),
                // const SizedBox(
                //   width: 5,
                // ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                )
              ],
            )),
      ),
    );
  }
}

class CustomCityDropDown extends StatelessWidget {
  const CustomCityDropDown({
    Key? key,
    this.isUpdate,
  }) : super(key: key);
  final bool? isUpdate;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SetUpBloc, SetUpStates>(
      listener: (BuildContext context, SetUpStates s) {},
      builder: (BuildContext context, SetUpStates s) =>
          BlocConsumer<CityBloc, SetUpStates>(
        listener: (context, state) {
          if (state is GetCitySuccess) {
            isUpdate == true
                ? AreaBloc.get(context).add(AreaEvent(
                    cityId: ProfileBloc.get(context).profileData!.cityId!))
                : null;
          }
        },
        builder: (BuildContext context, SetUpStates state) => state
                is GetCityLoading
            ? const LinearProgressIndicator(
                color: ColorManager.primaryColor,
              )
            : state is GetCitySuccess
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: Dimensions(context: context).textFieldHeight,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.buttonRadius),
                              border: Border.all(color: Colors.grey)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<CityModel>(
                              isExpanded: true,
                              elevation: 0,
                              menuMaxHeight: 300,
                              icon: Icon(
                                isUpdate == true
                                    ? Icons.edit_outlined
                                    : Icons.keyboard_arrow_down_sharp,
                                color: isUpdate == true
                                    ? ColorManager.primaryColor
                                    : Colors.transparent,
                              ),
                              value: SetUpBloc.get(context).cityDropModel,
                              items: state.cityList.map((CityModel cityValue) {
                                return DropdownMenuItem<CityModel>(
                                  value: cityValue,
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 5),
                                    child: Text(
                                      '${cityValue.city}',
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                SetUpBloc.get(context)
                                    .changeDropListCity(newValue);
                                SetUpBloc.get(context).changeMapValue(
                                    key: "CityId", value: newValue!.id);
                                AreaBloc.get(context)
                                    .add(AreaEvent(cityId: newValue.id!));

                                log(newValue.city.toString());
                              },
                              hint: Padding(
                                padding:
                                    const EdgeInsetsDirectional.only(start: 5),
                                child: Text(
                                  ProfileBloc.get(context).profileData?.city ??
                                      Strings.city,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
      ),
    );
  }
}

class CustomAreaDropDown extends StatelessWidget {
  CustomAreaDropDown({
    Key? key,
    this.isUpdate,
  }) : super(key: key);
  final bool? isUpdate;
  bool hasSetup = CacheHelper.getData(key: Strings.hasSetup) ?? false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SetUpBloc, SetUpStates>(
      listener: (BuildContext context, SetUpStates s) {},
      builder: (BuildContext context, SetUpStates s) =>
          BlocConsumer<AreaBloc, SetUpStates>(
        listener: (context, state) {
          if (state is GetCityFailed) {
            context.getSnackBar(snackText: state.message);
          }
        },
        builder: (BuildContext context, SetUpStates state) {
          // Determine the hint text
          String? hintText;
          if (state is GetAreaSuccess &&
              SetUpBloc.get(context).cityDropModel != null &&
              hasSetup == true) {
            hintText = state.areaList.first.area ?? Strings.area;
            SetUpBloc.get(context)
                .changeMapValue(key: "AreaId", value: state.areaList.first.id);
          } else if (hasSetup == false &&
              SetUpBloc.get(context).cityDropModel != null) {
            hintText = Strings.area;
          } else {
            hintText =
                ProfileBloc.get(context).profileData?.area ?? Strings.area;
          }

          return state is GetAreaLoading
              ? const LinearProgressIndicator(
                  color: ColorManager.primaryColor,
                )
              : state is GetAreaSuccess
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height:
                                Dimensions(context: context).textFieldHeight,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.buttonRadius),
                                border: Border.all(color: Colors.grey)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<AreaModel>(
                                isExpanded: true,
                                elevation: 0,
                                icon: Icon(
                                  isUpdate == true
                                      ? Icons.edit_outlined
                                      : Icons.keyboard_arrow_down_sharp,
                                  color: isUpdate == true
                                      ? ColorManager.primaryColor
                                      : Colors.transparent,
                                ),
                                menuMaxHeight: 300,
                                value: SetUpBloc.get(context).areaDropModel,
                                items:
                                    state.areaList.map((AreaModel areaValue) {
                                  return DropdownMenuItem<AreaModel>(
                                    value: areaValue,
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 5),
                                      child: Text(
                                        '${areaValue.area}',
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  SetUpBloc.get(context)
                                      .changeDropListArea(newValue);
                                  SetUpBloc.get(context).changeMapValue(
                                      key: "AreaId", value: newValue!.id);
                                  log(newValue.area.toString());
                                },
                                hint: Padding(
                                  padding:
                                      const EdgeInsetsDirectional.only(end: 5),
                                  child: Text(
                                    hintText,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox();
        },
      ),
    );
  }
}

// ElevatedButton(
//    onPressed: () {
//      _selectDate(context);
//    },
//    child: Text(
//      'Select date',
//    )

//  DropdownButtonHideUnderline(
//   child: DropdownButton<int>(
//     elevation: 0,
//     icon: const Icon(
//       Icons.edit_calendar_sharp,
//       color: ColorManager.primaryColor,
//     ),
//     value: SetUpBloc.get(context).setUpMap["BirthYear"],
//     items: years.map((int year) {
//       return DropdownMenuItem<int>(
//         value: year,
//         child: Padding(
//           padding: const EdgeInsetsDirectional.only(end: 20),
//           child: Text(
//             '$year',
//             style: const TextStyle(color: ColorManager.primaryColor),
//           ),
//         ),
//       );
//     }).toList(),
//     onChanged: (newValue) {
//       SetUpBloc.get(context)
//           .changeMapValue(key: "BirthYear", value: newValue);
//     },
//     hint: const Padding(
//       padding: EdgeInsetsDirectional.only(end: 20),
//       child: Text(
//         Strings.birthyear2,
//         style: TextStyle(color: ColorManager.primaryColor),
//       ),
//     ),
//   ),
// ),
