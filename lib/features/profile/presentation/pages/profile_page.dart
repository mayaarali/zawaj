import 'package:bubble/bubble.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/core/helper/profile_helper.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/add_image_box.dart';
import 'package:zawaj/core/widgets/build_dialog.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/core/widgets/loading_circle.dart';
import 'package:zawaj/features/age_and_place_of_birth/presentation/screens/age_and_place_of_birth_screen.dart';
import 'package:zawaj/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:zawaj/features/authentication/presentation/bloc/auth_event.dart';
import 'package:zawaj/features/authentication/presentation/bloc/auth_states.dart';
import 'package:zawaj/features/authentication/presentation/pages/login_signup/login_page.dart';
import 'package:zawaj/features/edit_image_and_name/presentation/logic/edit_image_and_name_cubit.dart';
import 'package:zawaj/features/edit_image_and_name/presentation/screens/edit_image_and_name.dart';
import 'package:zawaj/features/payment/presentation/pages/choose_bundle_screen.dart';
import 'package:zawaj/features/profile/data/models/profile_model.dart';
import 'package:zawaj/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:zawaj/features/profile/presentation/bloc/states.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/application_report/presentation/application_report_screen.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/consultants/presentation/screens/consultants.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/send_impression/presentation/screen/send_impression.dart';
import 'package:zawaj/features/profile/presentation/pages/popup_pages/settings/presentation/screen/setting.dart';
import 'package:zawaj/features/profile/presentation/pages/verification/verify_account_screen.dart';
import 'package:zawaj/features/removed_users/data/datasSource/removed_users_reomte_datasource.dart';
import 'package:zawaj/features/removed_users/data/repositories/removed_users_repository_impl.dart';
import 'package:zawaj/features/removed_users/domain/useCases/fetch_removed_users_usecase.dart';
import 'package:zawaj/features/removed_users/presentation/cubit/removed_user_cubit.dart';
import 'package:zawaj/features/removed_users/presentation/screens/removed_users_screen.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/city_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/params_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/setup_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/pages/update_profile_data.dart';
import 'package:zawaj/features/update_profile_picture/domain/useCase/concrete_update_profile_picture_use_case.dart';
import 'package:zawaj/features/update_profile_picture/presentation/cubit/update_profile_picture_cubit.dart';
import 'package:zawaj/features/update_profile_picture/presentation/screens/update_profile_picture_screen.dart';
import 'package:zawaj/injection_controller.dart' as di;

import '../../../setup_account/presentation/pages/set_partenal_data.dart';
import '../../../update_profile_picture/data/update_profile_picture_repository.dart';
import 'edit_profile/about_me/presentation/screen/about_me.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isShow = false;
  bool _isShowOthers = false;
  //bool isSubscribed = false;

  void showOtherEditsPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const OtherEditsPopUp();
      },
    );
  }

  @override
  void initState() {
    ProfileBloc.get(context).getMyProfile();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ProfileHelper.checkVerificationAndSubscription(context);
    });
    super.initState();
    // _loadSubscriptionStatus();
  }

  // Future<void> _loadSubscriptionStatus() async {
  //   final subscriptionStatus =
  //       await CacheHelper.getData(key: Strings.isSubscribed) ?? false;
  //   setState(() {
  //     isSubscribed = subscriptionStatus;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileStates>(
        listener: (BuildContext context, ProfileStates state) {},
        builder: (BuildContext context, ProfileStates state) {
          print(ProfileBloc.get(context).profileData);

          //  print(ProfileBloc.get(context).profileData!.verificationStatus);
          return CustomScaffold(
              isFullScreen: true,
              child: Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  SizedBox(
                    height: context.height,
                    width: context.width,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AppBar(
                              scrolledUnderElevation: 0,
                              elevation: 0,
                              shadowColor: Colors.white,
                              surfaceTintColor: Colors.transparent,
                              backgroundColor: Colors.white,
                              automaticallyImplyLeading: false,
                              centerTitle: true,
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Builder(
                                    builder: (BuildContext context) {
                                      final ProfileData? profileData =
                                          ProfileBloc.get(context).profileData;
                                      final String? verificationStatus =
                                          profileData?.verificationStatus;

                                      if (verificationStatus == null) {
                                        return IconButton(
                                          color: Colors.grey,
                                          onPressed: () {
                                            setState(() {
                                              _isShow = !_isShow;
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.check_circle_outline,
                                          ),
                                        );
                                      } else if (verificationStatus ==
                                          'Accepted') {
                                        return IconButton(
                                          color: Colors.green,
                                          onPressed: () {
                                            setState(() {
                                              _isShow = false;
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.check_circle_outline,
                                          ),
                                        );
                                      } else if (verificationStatus ==
                                          'Pending') {
                                        return IconButton(
                                          color: Colors.grey,
                                          icon: const Icon(
                                            Icons.check_circle_outline,
                                          ),
                                          onPressed: () {},
                                        );
                                      } else {
                                        return IconButton(
                                          color: Colors.grey,
                                          onPressed: () {
                                            setState(() {
                                              _isShow = !_isShow;
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.check_circle_outline,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: context.width * 0.5,
                                    child: CustomText(
                                      text: ProfileBloc.get(context)
                                                  .profileData ==
                                              null
                                          ? 'Name'
                                          : ProfileBloc.get(context)
                                                  .profileData!
                                                  .name ??
                                              'Name',
                                      fontSize: 20,
                                      textOverFlow: TextOverflow.ellipsis,
                                      lines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // const CustomAppBar(
                            //   title: "",
                            //   isMenuIcon: true,
                            //   isBack: false,
                            // ),
                            const SizedBox(
                              height: 10,
                            ),
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        if (ProfileBloc.get(context)
                                                    .profileData ==
                                                null ||
                                            ProfileBloc.get(context)
                                                .profileData!
                                                .images!
                                                .isEmpty)
                                          AddImageBox(
                                              context.height * 0.2,
                                              context.height * 0.2,
                                              null,
                                              () {}, () {
                                            MagicRouter.navigateTo(BlocProvider(
                                              create: (context) =>
                                                  UpdateProfilePictureCubit(
                                                ConcreteUpdateProfilePictureUseCase(
                                                    UpdateProfilePictureRepository()),
                                              ),
                                              child: UpdateProfilePictureScreen(
                                                pictures:
                                                    ProfileBloc.get(context)
                                                        .profileData!
                                                        .images!,
                                              ),
                                            ));
                                          })
                                        else
                                          Stack(
                                            children: [
                                              ClipRRect(
                                                  borderRadius: BorderRadius.circular(
                                                      Dimensions.buttonRadius),
                                                  child: Image.network(
                                                      EndPoints.BASE_URL_image +
                                                          ProfileBloc.get(context)
                                                              .profileData!
                                                              .images![0],
                                                      height:
                                                          context.height * 0.2,
                                                      width:
                                                          context.height * 0.2,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                    return Container(
                                                      color: Colors.white,
                                                      height:
                                                          context.height * 0.2,
                                                      width:
                                                          context.height * 0.2,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Center(
                                                            child: Image.asset(
                                                              ImageManager
                                                                  .profileError,
                                                              fit: BoxFit
                                                                  .scaleDown,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }, frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                                    return child;
                                                  }, loadingBuilder: (context, child, loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    } else {
                                                      return Shimmer.fromColors(
                                                        baseColor:
                                                            Colors.grey[300]!,
                                                        highlightColor:
                                                            Colors.grey[100]!,
                                                        child: Container(
                                                          height:
                                                              context.height *
                                                                  0.2,
                                                          width:
                                                              context.height *
                                                                  0.2,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  })),
                                              Positioned(
                                                bottom: 0,
                                                right: 0,
                                                child: InkWell(
                                                  onTap: () {
                                                    MagicRouter.navigateTo(
                                                        BlocProvider(
                                                      create: (context) =>
                                                          UpdateProfilePictureCubit(
                                                        ConcreteUpdateProfilePictureUseCase(
                                                            UpdateProfilePictureRepository()),
                                                      ),
                                                      child:
                                                          UpdateProfilePictureScreen(
                                                        pictures:
                                                            ProfileBloc.get(
                                                                    context)
                                                                .profileData!
                                                                .images!,
                                                      ),
                                                    ));
                                                  },
                                                  child: const Icon(
                                                    Icons.edit_outlined,
                                                    color: ColorManager
                                                        .primaryColor,
                                                    size: 35.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                //popup checkaccount

                                Visibility(
                                  visible: _isShow,
                                  child: Positioned(
                                    right: context.width * -0.02,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 22),
                                      child: InkWell(
                                        onTap: () {
                                          MagicRouter.navigateTo(
                                              const VerifyScreen());
                                        },
                                        child: Bubble(
                                          margin: const BubbleEdges.only(
                                              bottom: 10),
                                          nip: BubbleNip.leftBottom,
                                          color:
                                              ColorManager.secondaryPinkColor,
                                          child: const CustomText(
                                            text: Strings.check_account,
                                            align: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            const SizedBox(
                              height: 30,
                            ),
                            CommanProfileButton(
                              text: 'الاسم والصور',
                              onTap: () {
                                MagicRouter.navigateTo(BlocProvider(
                                  create: (context) =>
                                      EditImageAndNameCubit(Dio()),
                                  child: EditImageAndNameScreen(
                                    pictures: ProfileBloc.get(context)
                                        .profileData!
                                        .images!,
                                    name: ProfileBloc.get(context)
                                        .profileData!
                                        .name!,
                                  ),
                                ));
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CommanProfileButton(
                              text: 'العمر ومكان الميلاد',
                              onTap: () {
                                MagicRouter.navigateTo(MultiBlocProvider(
                                  providers: [
                                    // BlocProvider(
                                    //   create: (context) =>
                                    //       di.sl<CityBloc>()..getCity(),
                                    // ),
                                    BlocProvider(
                                      create: (context) => di.sl<SetUpBloc>(),
                                    ),
                                    BlocProvider(
                                      create: (context) => di.sl<ParamsBloc>()
                                        ..getParams(context),
                                    )
                                  ],
                                  child: AgeAndPlaceOfBirteScreen(
                                    age: ProfileBloc.get(context)
                                        .profileData!
                                        .age!,
                                    area: ProfileBloc.get(context)
                                        .profileData!
                                        .area!,
                                    country: ProfileBloc.get(context)
                                        .profileData!
                                        .city!,
                                  ),
                                ));
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CommanProfileButton(
                              text: 'مواصفاتي الشخصية',
                              onTap: () {
                                MagicRouter.navigateTo(UpdateProfileData(
                                  isUpdate: true,
                                ));

                                // MagicRouter.navigateTo(const MyProfileData());
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CommanProfileButton(
                              text: 'نبدة تعريفية',
                              onTap: () {
                                MagicRouter.navigateTo(BlocProvider(
                                  create: (_) => di.sl<ProfileBloc>()
                                    ..getMyProfile()
                                    ..getMyPartner(),
                                  child: AboutMe(),
                                ));
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const CustomText(
                                  text: Strings.mainly,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                  align: TextAlign.start,
                                ),
                                CustomText(
                                  text: ProfileBloc.get(context)
                                              .profileData!
                                              .isSubscribed ==
                                          true
                                      ? Strings.not_mainly
                                      : "أساسية",
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                  align: TextAlign.start,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            ProfileBloc.get(context)
                                        .profileData!
                                        .isSubscribed ==
                                    false
                                ? CustomButton(
                                    onTap: () {
                                      MagicRouter.navigateTo(ChooseBundle(
                                        userId: ProfileBloc.get(context)
                                            .profileData!
                                            .userId!,
                                        isFromProfileScreen: true,
                                      ));
                                    },
                                    text: Strings.get_best)
                                : const SizedBox(),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomButton(
                              onTap: () {
                                MagicRouter.navigateTo(
                                    SetPartnerData(isUpdated: true));
                                // MagicRouter.navigateTo(const MyPartnerData());
                              },
                              text: Strings.partner,
                              txtColor: ColorManager.primaryColor,
                              borderColor: ColorManager.primaryColor,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              child: const CustomText(
                                text: Strings.delete_account,
                                color: Colors.red,
                                decorationColor: Colors.red,
                                textDecoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                              ),
                              onTap: () async {
                                buildDialog(
                                    isDoubleBtn: true,
                                    optionalButtonTitle: 'إلغاء',
                                    context: context,
                                    onTapCancell: () {
                                      MagicRouter.goBack();
                                    },
                                    onTapEnter: () async {
                                      await ProfileBloc.get(context)
                                          .deleteMyProfile();
                                      await CacheHelper.removeData(
                                          key: Strings.token);
                                      await CacheHelper.removeData(
                                          key: Strings.hasSetup);
                                      await CacheHelper.removeData(
                                          key: Strings.hasRequired);
                                      await CacheHelper.removeAllData();

                                      MagicRouter.navigateAndPopAll(
                                          const LoginPage());
                                    },
                                    buttonTitle: Strings.yes,
                                    title: Strings.delete_account,
                                    desc: Strings.deleteAccountConfirm);
                              },
                            ),

                            const SizedBox(
                              height: 7,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _isShowOthers,
                    child: const SizedBox(
                      width: 250,
                      child: OtherEditsPopUp(),
                    ),
                  )
                ],
              ));
        });
  }

  Widget buildRow(text, onTap) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: CustomText(
                text: text,
                fontWeight: FontWeight.normal,
                fontSize: Dimensions.normalFont,
                align: TextAlign.start,
              )),
              const Icon(
                Icons.arrow_forward_ios,
                color: ColorManager.primaryColor,
              )
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Divider(
            color: ColorManager.secondaryPinkColor,
            thickness: 2,
          ),
        )
      ],
    );
  }
}

class OtherEditsPopUp extends StatelessWidget {
  const OtherEditsPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: 50,
      // height: context.height * 0.5,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(Dimensions.buttonRadius),
                topEnd: Radius.circular(Dimensions.buttonRadius),
                bottomStart: Radius.circular(Dimensions.buttonRadius))),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              InkWell(
                  onTap: () {
                    MagicRouter.navigateTo(BlocProvider(
                      create: (context) => UserCubit(FetchUsersUseCase(
                          UserRepositoryImpl(
                              RemovedUsersRemoteDataSource(Dio()))))
                        ..fetchUsers(),
                      child: const RemovedUsersListScreen(),
                    ));
                  },
                  child: const CustomText(
                    text: Strings.deletedUsers,
                  )),
              Divider(
                color: ColorManager.hintTextColor.withOpacity(0.5),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                  onTap: () {
                    MagicRouter.navigateTo(const ConsultantsScreen());
                  },
                  child: const CustomText(
                    text: Strings.consultant,
                  )),
              Divider(
                color: ColorManager.hintTextColor.withOpacity(0.5),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                  onTap: () {
                    MagicRouter.navigateTo(ApplicationReport());
                  },
                  child: const CustomText(
                    text: Strings.report,
                  )),
              Divider(
                color: ColorManager.hintTextColor.withOpacity(0.5),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                  onTap: () {
                    MagicRouter.navigateTo(SendImpression());
                  },
                  child: const CustomText(text: Strings.review)),
              Divider(
                color: ColorManager.hintTextColor.withOpacity(0.5),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                  onTap: () {
                    MagicRouter.navigateTo(const Setting());
                  },
                  child: const CustomText(text: Strings.setting)),
              Divider(
                color: ColorManager.hintTextColor.withOpacity(0.5),
              ),
              const SizedBox(
                height: 10,
              ),
              BlocConsumer<AuthBloc, AuthStates>(
                listener: (context, state) async {
                  if (state is LogOutSuccess) {
                    await FirebaseAuth.instance.signOut();
                    GoogleSignIn googleSignIn = GoogleSignIn();
                    googleSignIn.disconnect();

                    // await CacheHelper.removeData(key: Strings.token);
                    await CacheHelper.removeData(key: Strings.hasSetup);
                    await CacheHelper.removeData(key: Strings.hasRequired);
                    await CacheHelper.removeAllData();

                    MagicRouter.navigateAndPopAll(const LoginPage());
                  }
                },
                builder: (context, state) {
                  return InkWell(
                      onTap: () {
                        buildDialog(
                            context: context,
                            onTapEnter: () async {
                              OneSignal.logout();

                              AuthBloc.get(context).add(LogOutEvent());
                              await FirebaseAuth.instance.signOut();
                              // GoogleSignIn googleSignIn = GoogleSignIn();
                              // googleSignIn.disconnect();

                              // await CacheHelper.removeData(key: Strings.token);
                              // await CacheHelper.removeData(
                              //     key: Strings.hasSetup);
                              // await CacheHelper.removeData(
                              //     key: Strings.hasRequired);
                              // await CacheHelper.removeAllData();

                              // MagicRouter.navigateAndPopAll(const LoginPage());
                            },
                            onTapCancell: () {
                              MagicRouter.goBack();
                            },
                            optionalButtonTitle: Strings.no,
                            isDoubleBtn: true,
                            buttonTitle: Strings.yes,
                            title: Strings.logout,
                            desc: Strings.logout_confirm);
                      },
                      child: const CustomText(text: Strings.exit));
                },
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommanProfileButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CommanProfileButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: context.height * 0.08,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.buttonRadius),
          border: Border.all(
            color: ColorManager.borderColor,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: ColorManager.borderColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
