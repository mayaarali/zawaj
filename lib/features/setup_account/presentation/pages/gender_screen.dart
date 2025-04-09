import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/custom_appbar.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/features/authentication/presentation/pages/login_signup/login_page.dart';
import 'package:zawaj/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/params_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/setup_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/states.dart';
import 'package:zawaj/features/setup_account/presentation/pages/age_screen.dart';
import 'package:zawaj/features/setup_account/presentation/pages/set_personal_data.dart';
import 'package:zawaj/injection_controller.dart' as di;

import '../bloc/area_bloc.dart';
import '../bloc/city_bloc.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  @override
  void initState() {
    SetUpBloc.get(context).defaultSetUpMap();
    SetUpBloc.get(context).multiSelectList = [];
    SetUpBloc.get(context).heightController.clear();
    SetUpBloc.get(context).weightController.clear();
    SetUpBloc.get(context).selectedDone = false;
    ProfileBloc.get(context).getMyProfile();
    // if (ParamsBloc.get(context).paramsList.isNotEmpty) {
    //   SetUpBloc.get(context)
    //       .fillSetupCollectList(ParamsBloc.get(context).paramsList);
    // }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        isFullScreen: true,
        child: BlocConsumer<SetUpBloc, SetUpStates>(
          listener: (BuildContext context, SetUpStates state) {},
          builder: (BuildContext context, SetUpStates state) =>
              SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CustomAppBar(
                  title: Strings.who_are_you,
                  isBack: false,
                ),
                const CustomStepper(
                  pageNumber: 0,
                ),
                // const CustomRadios(3),
                SizedBox(
                  height: context.height * 0.09,
                ),
                const CustomText(
                  text: Strings.registar_deatlis,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontSize: 20,
                ),
                SizedBox(
                  height: context.height * 0.09,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () {
                          SetUpBloc.get(context)
                              .changeMapValue(key: "Gender", value: 0);
                          SetUpBloc.get(context)
                              .changeMapValue(key: "SearchGender", value: 1);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 1.5,
                                    color: SetUpBloc.get(context)
                                                .setUpMap["Gender"] ==
                                            0
                                        ? ColorManager.primaryColor
                                        : Colors.grey)),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Image.asset(ImageManager.male),
                            ))),
                    SizedBox(
                      width: context.width * 0.15,
                    ),

                    // SizedBox(
                    //   height: context.height * 0.09,
                    // ),
                    const CustomText(
                      text: Strings.me,
                      fontWeight: FontWeight.normal,
                      fontSize: 30,
                    ),
                    SizedBox(
                      width: context.width * 0.15,
                    ),
                    InkWell(
                        onTap: () {
                          SetUpBloc.get(context)
                              .changeMapValue(key: "Gender", value: 1);
                          SetUpBloc.get(context)
                              .changeMapValue(key: "SearchGender", value: 0);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 1.5,
                                    color: SetUpBloc.get(context)
                                                .setUpMap["Gender"] ==
                                            1
                                        ? ColorManager.primaryColor
                                        : Colors.grey)),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Image.asset(ImageManager.female),
                            ))),
                  ],
                ),

                // const CustomText(
                //   text: Strings.search_for,
                //   fontWeight: FontWeight.normal,
                // ),
                SizedBox(
                  height: context.height * 0.04,
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     InkWell(
                //         onTap: () {
                //           SetUpBloc.get(context)
                //               .changeMapValue(key: "SearchGender", value: 0);
                //           SetUpBloc.get(context)
                //               .changeMapValue(key: "Gender", value: 1);
                //         },
                //         child: Container(
                //             decoration: BoxDecoration(
                //                 borderRadius: BorderRadius.circular(8),
                //                 border: Border.all(
                //                     width: 1.5,
                //                     color: SetUpBloc.get(context)
                //                                 .setUpMap["SearchGender"] ==
                //                             0
                //                         ? ColorManager.primaryColor
                //                         : Colors.grey)),
                //             child: Padding(
                //               padding: const EdgeInsets.all(5),
                //               child: Image.asset(ImageManager.male),
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
                //           SetUpBloc.get(context)
                //               .changeMapValue(key: "SearchGender", value: 1);
                //           SetUpBloc.get(context)
                //               .changeMapValue(key: "Gender", value: 0);
                //         },
                //         child: Container(
                //             decoration: BoxDecoration(
                //                 borderRadius: BorderRadius.circular(8),
                //                 border: Border.all(
                //                     width: 1.5,
                //                     color: SetUpBloc.get(context)
                //                                 .setUpMap["SearchGender"] ==
                //                             1
                //                         ? ColorManager.primaryColor
                //                         : Colors.grey)),
                //             child: Padding(
                //               padding: const EdgeInsets.all(5),
                //               child: Image.asset(ImageManager.female),
                //             ))),
                //   ],
                // ),
                // SizedBox(
                //   height: context.height * 0.06,
                // ),
                // const Align(
                //   alignment: Alignment.centerRight,
                //   child: CustomText(
                //     text: Strings.my_name_in_arabic,
                //     fontWeight: FontWeight.normal,
                //     color: Colors.black,
                //     fontSize: 15,
                //   ),
                // ),
                // SizedBox(
                //   height: context.height * 0.02,
                // ),
                //   CustomTextField(
                //     controller: SetUpBloc.get(context).controllerName,
                //     validate: (v) => Validator.validateName(v),
                //     hintText: Strings.my_name_in_arabic,
                //   ),
                //   SizedBox(
                //     height: context.height * 0.02,
                //   ),
                const Align(
                  alignment: Alignment.centerRight,
                  child: CustomText(
                    text: Strings.birth_date,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: context.height * 0.02,
                ),
                const YearDropdownWidget(),
                SizedBox(
                  height: context.height * 0.02,
                ),
                const Align(
                  alignment: Alignment.centerRight,
                  child: CustomText(
                    text: Strings.where_are_you_from,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: context.height * 0.02,
                ),
                MultiBlocProvider(
                  providers: [
                    // BlocProvider(
                    //   create: (context) => di.sl<CityBloc>()..getCity(),
                    // ),
                    // BlocProvider(
                    //   create: (context) => di.sl<AreaBloc>(),
                    // ),
                    // BlocProvider(
                    //   create: (context) =>
                    //       di.sl<ParamsBloc>()..getParams(context),
                    // ),
                    // BlocProvider(
                    //   create: (context) => di.sl<SetUpBloc>()..cityDropModel,
                    // ),
                    BlocProvider(
                      create: (context) => di.sl<ProfileBloc>()..profileData,
                    ),
                  ],
                  child: BlocBuilder<SetUpBloc, SetUpStates>(
                    builder: (context, state) {
                      return Row(
                        children: [
                          const Expanded(child: CustomCityDropDown()),
                          SizedBox(
                            width: context.width * 0.015,
                          ),
                          Expanded(child: CustomAreaDropDown()),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: context.height * 0.03,
                ),
                CustomButton(
                  text: Strings.next,
                  onTap: () {
                    //  if (SetUpBloc.get(context).controllerName.text.isEmpty) {
                    //    context.getSnackBar(
                    //        snackText: 'يجب اضافة اسمك', isError: true);
                    //  } else
                    if (SetUpBloc.get(context).setUpMap["BirthDay"] == null) {
                      context.getSnackBar(
                          snackText: 'يجب إضافة تاريخ ميلادك', isError: true);
                    } else if (SetUpBloc.get(context).setUpMap["CityId"] ==
                        null) {
                      context.getSnackBar(
                          snackText: 'يجب إضافة مدينتك', isError: true);
                    } else if (SetUpBloc.get(context).setUpMap["AreaId"] ==
                        null) {
                      context.getSnackBar(
                          snackText: 'يجب إضافة منطقتك', isError: true);
                    } else {
                      print(
                          '===========================================================');
                      print(CacheHelper.getData(key: Strings.Name));
                      SetUpBloc.get(context).changeMapValue(
                          key: "Name",
                          value:
                              CacheHelper.getData(key: Strings.Name) ?? 'Name');
                      //MagicRouter.navigateTo(MaritalStatus());
                      MagicRouter.navigateTo(SetPersonalData());
                    }

                    // if (SetUpBloc.get(context).controllerName.text == '') {
                    //   //  context.getSnackBar(snackText: "You must add Name", isError: true);
                    //   showToast(
                    //       msg: 'يجب اضافة اسمك',
                    //       gravity: ToastGravity.BOTTOM,
                    //       textColor: ColorManager.primaryColor);
                    // } else {
                    //   SetUpBloc.get(context).changeMapValue(
                    //       key: "Name",
                    //       value: SetUpBloc.get(context).controllerName.text);
                    //   MagicRouter.navigateTo(const AgeScreen());
                    // }
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  child: const CustomText(
                    text: Strings.changeEmail,
                    color: ColorManager.greyTextColor,
                    decorationColor: ColorManager.greyTextColor,
                    textDecoration: TextDecoration.underline,
                  ),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    GoogleSignIn googleSignIn = GoogleSignIn();
                    googleSignIn.disconnect();

                    await CacheHelper.removeData(key: Strings.token);
                    await CacheHelper.removeData(key: Strings.hasSetup);
                    await CacheHelper.removeData(key: Strings.hasRequired);
                    await CacheHelper.removeAllData();
                    MagicRouter.navigateAndPopAll(const LoginPage());
                  },
                )
              ],
            ),
          ),
        ));
  }
}

class CustomStepper extends StatelessWidget {
  final int pageNumber;

  const CustomStepper({super.key, required this.pageNumber});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStep(
                isCurrentStep: pageNumber == 0,
                isCompleted: pageNumber > 0,
                text: Strings.who_are_you,
                textColor: ColorManager.primaryColor),
            _buildLine(
              context,
              color: pageNumber >= 1 ? ColorManager.primaryColor : Colors.grey,
            ),
            _buildStep(
              isCurrentStep: pageNumber == 1,
              isCompleted: pageNumber > 1,
              text: Strings.my_specifications,
              textColor:
                  pageNumber >= 1 ? ColorManager.primaryColor : Colors.grey,
            ),
            _buildLine(
              context,
              color: pageNumber >= 2 ? ColorManager.primaryColor : Colors.grey,
            ),
            _buildStep(
              isCurrentStep: pageNumber == 2,
              isCompleted: false,
              text: Strings.my_photos,
              textColor:
                  pageNumber == 2 ? ColorManager.primaryColor : Colors.grey,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep(
      {required bool isCurrentStep,
      required bool isCompleted,
      required String text,
      Color? textColor}) {
    return Column(
      children: [
        isCompleted
            ? _buildSuccessCircle()
            : _buildCircle(
                borderColor:
                    isCurrentStep ? ColorManager.primaryColor : Colors.grey,
                iconColor: isCurrentStep
                    ? ColorManager.primaryColor
                    : Colors.transparent,
              ),
        const SizedBox(height: 4),
        CustomText(
          text: text,
          fontSize: 10,
          color: textColor ??
              (isCurrentStep ? ColorManager.primaryColor : Colors.grey),
        ),
      ],
    );
  }

  Widget _buildCircle({required Color borderColor, required Color iconColor}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
      ),
      child: CircleAvatar(
        radius: 21,
        backgroundColor: ColorManager.whiteTextColor,
        child: Icon(
          Icons.fiber_manual_record_sharp,
          color: iconColor,
          size: 21,
        ),
      ),
    );
  }

  Widget _buildSuccessCircle() {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.primaryColor,
        shape: BoxShape.circle,
        border: Border.all(color: ColorManager.primaryColor, width: 2),
      ),
      child: const CircleAvatar(
        radius: 21,
        backgroundColor: ColorManager.primaryColor,
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 21,
        ),
      ),
    );
  }

  Widget _buildLine(BuildContext context, {required Color color}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.only(bottom: context.height * 0.02),
        height: 2,
        color: color,
      ),
    );
  }
}
