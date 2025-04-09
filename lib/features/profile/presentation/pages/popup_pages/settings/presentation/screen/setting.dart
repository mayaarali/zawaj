import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/build_dialog.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/features/authentication/presentation/pages/login_signup/login_page.dart';
import 'package:zawaj/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:zawaj/features/profile/presentation/bloc/states.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/settings/presentation/cubit/cubit.dart';

import '../../../../../../../../core/constants/dimensions.dart';
import '../../../../../../../../core/constants/strings.dart';
import '../../../../../../../../core/widgets/custom_appbar.dart';
import '../../../../../../../../core/widgets/custom_button.dart';

class Setting extends StatefulWidget {
  const Setting({
    super.key,
  });

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  late NotificationsToggleCubit notificationsToggleCubit;
  // final ProfileData profileData;
  @override
  void initState() {
    ProfileBloc.get(context).getMyProfile();
    //ProfileBloc.get(context).deleteMyProfile();

    notificationsToggleCubit = NotificationsToggleCubit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*return BlocBuilder<NotificationsToggleCubit, Map<String, bool>>(
      builder: (context, state) {
        //print(ProfileBloc.get(context).profileData);
        */
    return CustomScaffold(
        bottomNavigationBar: SizedBox(
          height: 100,
          width: context.width,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                child: const CustomText(
                  text: Strings.delete_account,
                  textDecoration: TextDecoration.underline,
                  fontWeight: FontWeight.normal,
                ),
                onTap: () async {
                  print('object');

                  buildDialog(
                      isDoubleBtn: true,
                      optionalButtonTitle: 'إلغاء',
                      context: context,
                      onTapCancell: () {
                        MagicRouter.goBack();
                      },
                      onTapEnter: () async {
                        await ProfileBloc.get(context).deleteMyProfile();
                        await CacheHelper.removeData(key: Strings.token);
                        await CacheHelper.removeData(key: Strings.hasSetup);
                        await CacheHelper.removeData(key: Strings.hasRequired);
                        await CacheHelper.removeAllData();

                        MagicRouter.navigateAndPopAll(const LoginPage());
                      },
                      buttonTitle: Strings.yes,
                      title: Strings.delete_account,
                      desc: Strings.deleteAccountConfirm);
                },
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        isFullScreen: true,
        child: SafeArea(
          child: BlocConsumer<NotificationsToggleCubit, Map<String, bool>>(
            listener: (context, state) async {
              if (notificationsToggleCubit.isloading == true) {
                // showDialog(
                //     context: context,
                //     barrierDismissible: false,
                //     builder: (context) => const LoadingPopUp());
              }
            },
            builder: (context, state) =>
                BlocConsumer<ProfileBloc, ProfileStates>(
              listener: (context, state) async {
                if (state is DeleteProfileLoading) {
                  const CircularProgressIndicator();
                } else if (state is DeleteProfileSuccess) {
                  await CacheHelper.removeAllData();
                  await CacheHelper.removeData(key: Strings.token);
                  await CacheHelper.removeData(key: Strings.hasSetup);
                  await CacheHelper.removeData(key: Strings.hasRequired);
                  MagicRouter.navigateAndPopAll(LoginPage());
                } else if (state is DeleteProfileFailed) {
                  context.getSnackBar(snackText: state.message, isError: true);
                }
              },
              builder: (context, state) {
                print(ProfileBloc.get(context).profileData);
                return Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const CustomAppBar(
                      title: '',
                      //    leading: CustomText(
                      //      text: Strings.finished,
                      //      fontWeight: FontWeight.normal,
                      //    ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomText(
                          text: Strings.notification,
                          fontSize: Dimensions.largeFont,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SwitchButton(
                      text: Strings.new_couples,
                      index: 0,
                      onChanged: (value) {
                        //context.read<NotificationsToggleCubit>()
                        notificationsToggleCubit.toggleFeature(
                            'notification', value, context);
                      },
                      switchState: ProfileBloc.get(context).profileData == null
                          ? false
                          : ProfileBloc.get(context)
                                  .profileData!
                                  .notificationSetting ??
                              false,
                    ),
                    SwitchButton(
                      text: Strings.msgs,
                      index: 1,
                      onChanged: (value) {
                        //context.read<NotificationsToggleCubit>()
                        notificationsToggleCubit.toggleFeature(
                            'message', value, context);
                        ProfileBloc.get(context).getMyProfile();
                      },
                      switchState: ProfileBloc.get(context).profileData == null
                          ? false
                          : ProfileBloc.get(context)
                                  .profileData!
                                  .messageSetting ??
                              false,
                      //profileData.messageSetting ?? false,
                    ),
                    SwitchButton(
                      text: Strings.likes,
                      index: 2,
                      onChanged: (value) {
                        // context.read<NotificationsToggleCubit>()
                        notificationsToggleCubit.toggleFeature(
                            'like', value, context);
                        ProfileBloc.get(context).getMyProfile();
                      },
                      switchState: ProfileBloc.get(context).profileData == null
                          ? false
                          : ProfileBloc.get(context).profileData!.likeSetting ??
                              false,
                      // profileData.likeSetting ?? false
                      //state['like'] ?? false,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                );
              },
            ),
          ),
        ));
  }
  //  );
}
//}

class SwitchButton extends StatelessWidget {
  const SwitchButton({
    super.key,
    required this.index,
    required this.text,
    required this.switchState,
    required this.onChanged,
  });

  final int index;
  final Function(bool) onChanged;
  final bool switchState;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: text,
              fontSize: Dimensions.normalFont,
            ),
            CupertinoSwitch(
              activeColor: ColorManager.primaryColor,
              value: switchState,
              onChanged: onChanged,
            ),
          ],
        ),
        Divider(
          color: ColorManager.hintTextColor.withOpacity(0.5),
        )
      ],
    );
  }
}
