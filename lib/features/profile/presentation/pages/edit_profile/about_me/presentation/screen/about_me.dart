import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:popover/popover.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/validator/validator.dart';
import 'package:zawaj/core/widgets/custom_appbar.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/core/widgets/custom_text_field.dart';
import 'package:zawaj/core/widgets/toast.dart';
import 'package:zawaj/features/profile/data/models/profile_model.dart';
import 'package:zawaj/features/profile/presentation/bloc/states.dart';
import 'package:zawaj/features/profile/presentation/pages/edit_profile/about_me/data/model/model.dart';
import 'package:zawaj/features/profile/presentation/pages/edit_profile/about_me/presentation/cubit/cubit.dart';

import '../../../../../../../../core/constants/dimensions.dart';
import '../../../../../../../../core/widgets/custom_button.dart';
import '../../../../../bloc/profile_bloc.dart';

class AboutMe extends StatefulWidget {
  AboutMe({super.key});

  @override
  State<AboutMe> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  final TextEditingController _aboutMecontroller = TextEditingController();
  @override
  void initState() {
    ProfileBloc.get(context).profileData;
//    ProfileBloc.get(context).profileData!.about.toString();
    //  updateAboutMeText(ProfileBloc.get(context).profileData);
    super.initState();
  }

  void updateAboutMeText(ProfileData? profileData) {
    if (profileData == null || profileData.about == null) {
      //_aboutMecontroller.text = Strings.write_about_yourself;
    } else {
      _aboutMecontroller.text = profileData.about.toString();
    }
  }

  final GlobalKey<FormState> _formKeyy = GlobalKey<FormState>();

  // final _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AboutCubit(),
      child: BlocConsumer<AboutCubit, AboutState>(
        listener: (context, state) {
          ProfileBloc.get(context).profileData == null
              ? Strings.write_about_yourself
              : ProfileBloc.get(context).profileData!.about.toString() == 'null'
                  ? Strings.write_about_yourself
                  : ProfileBloc.get(context).profileData!.about.toString();
          if (state is AboutSuccess) {
            context.getSnackBar(
              snackText: Strings.aboutAddedSuccessfully,
              isError: false,
            );
          } else if (state is AboutError) {
            showDialog(
                context: context,
                barrierDismissible: true,
                barrierColor: ColorManager.primaryColor.withOpacity(0.5),
                builder: (context) => AlertDialog(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(30.0))),
                      title: Column(children: [
                        Icon(
                          Icons.warning_rounded,
                          color: ColorManager.primaryColor,
                          size: 50,
                        ),
                      ]),
                      content: PopUpCard(
                        msg: Strings.error,
                      ),
                    ));
          }
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              print('Unfocus************************');
              FocusScope.of(context).unfocus();
              //  _focusNode.unfocus();
            },
            child: CustomScaffold(
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CustomButton(
                      onTap: () {
                        if (_formKeyy.currentState!.validate()) {
                          if (context.read<AboutCubit>().isLoading == false) {
                            final data = AboutMeData(_aboutMecontroller.text);
                            context.read<AboutCubit>().addAbout(data);
                            ProfileBloc.get(context).profileData;
                            ProfileBloc.get(context)
                                .profileData!
                                .about
                                .toString();
                          }
                        }
                      },
                      text: Strings.save),
                ),
                isFullScreen: true,
                child: Column(
                  children: [
                    const CustomAppBar(
                      title: 'نبدة تعريفية',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocConsumer<ProfileBloc, ProfileStates>(
                      listener: (context, state) {
                        if (state is SuccessProfile) {
                          updateAboutMeText(state.profileData);
                        }
                      },
                      builder: (context, state) {
                        return Form(
                          key: _formKeyy,
                          child: CustomTextField(
                            validate: (v) {
                              return Validator.validateBio(v);
                            },
                            controller: _aboutMecontroller,
                            hintText:
                                ProfileBloc.get(context).profileData == null
                                    ? Strings.write_about_yourself
                                    : ProfileBloc.get(context)
                                                .profileData!
                                                .about
                                                .toString() ==
                                            'null'
                                        ? Strings.write_about_yourself
                                        : ProfileBloc.get(context)
                                            .profileData!
                                            .about
                                            .toString(),
                            hintTextColor: Colors.black,
                            maxLines: 5,
                            height:
                                Dimensions(context: context).textFieldHeight *
                                    3,
                            onChanged: (text) {
                              setState(() {
                                if (!isArabic(text: text)) {}
                              });
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    isArabic(text: _aboutMecontroller.text) ||
                            _aboutMecontroller.text.isEmpty
                        ? Container()
                        : const Align(
                            alignment: Alignment.centerRight,
                            child: CustomText(
                              text:
                                  'It\'s better the description to be in Arabic',
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: Dimensions.normalFont,
                            ),
                          ),
                  ],
                )),
          );
        },
      ),
    );
  }

  bool isArabic({required String text}) {
    final pattern = RegExp(r'^[\u0600-\u06FF0-9\s]+$');
    return pattern.hasMatch(text);
  }
}

class PopUpCard extends StatelessWidget {
  PopUpCard({super.key, this.msg});
  String? msg;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(
          text: msg,
          fontSize: Dimensions.mediumFont,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}
