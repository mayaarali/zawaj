import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/add_image_box.dart';
import 'package:zawaj/core/widgets/custom_appbar.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/core/widgets/loading_circle.dart';
import 'package:zawaj/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:zawaj/features/profile/presentation/bloc/states.dart';
import 'package:zawaj/features/profile/presentation/pages/verification/presentation/bloc/verify_bloc.dart';
import 'package:zawaj/features/setup_account/presentation/pages/gender_screen.dart';
import 'package:zawaj/injection_controller.dart' as di;

import '../../../../setup_account/presentation/bloc/area_bloc.dart';
import '../../../../setup_account/presentation/bloc/city_bloc.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  @override
  void initState() {
    ProfileBloc.get(context).profileData;
    //VerifyBloc.get(context).selectFromGallery(context, 0);
    // var verifyBloc = VerifyBloc.get(context);
    //verifyBloc.add(Verification());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(
      VerifyBloc.get(context).image1,
    );

    return CustomScaffold(
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(30.0),
      //   child: CustomButton(onTap: () {}, text: Strings.congrats),
      // ),
      isFullScreen: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const CustomAppBar(
              isBack: true,
              isLogoTitle: true,
            ),
            BlocConsumer<ProfileBloc, ProfileStates>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                return BlocConsumer<VerifyBloc, VerifyState>(
                    listener: (context, state) {
                      if (state is VerifySuccess) {
                        //  MagicRouter.navigateTo(const ProfilePage());
                        MagicRouter.navigateAndPopAll(MultiBlocProvider(
                          providers: [
                            // BlocProvider(
                            //   create: (context) => di.sl<CityBloc>()..getCity(),
                            // ),
                            // BlocProvider(
                            //   create: (context) => di.sl<AreaBloc>(),
                            // ),
                            BlocProvider(
                              create: (context) => di.sl<ProfileBloc>()
                                ..getMyProfile()
                                ..partnerData,
                            ),
                          ],
                          child: GenderScreen(),
                        ));
                        CacheHelper.setData(
                            key: Strings.verificationState, value: 'Pending');
                      } else if (state is VerifyFailure) {
                        context.getSnackBar(snackText: state.message);
                      }
                    },
                    builder: (context, state) =>
                        //state is VerifyLoading
                        //  ? const LoadingCircle()
                        // : state is VerifySuccess
                        //?

                        Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CustomText(
                                text: Strings.lastStep,
                                fontSize: Dimensions.largeFont,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const CustomText(
                              text: Strings.takePhoto,
                              color: ColorManager.greyTextColor,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SvgPicture.asset(ImageManager.idImage),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: AddImageBar(
                                  Strings.chooseSelfie,
                                  context.height * 0.07,
                                  context.width,
                                  VerifyBloc.get(context).image1, () {
                                VerifyBloc.get(context).removeImage(0);
                              }, () {
                                VerifyBloc.get(context)
                                    .selectFromGallery(context, 0);
                              }),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: AddImageBar(
                                  Strings.chooseID,
                                  context.height * 0.07,
                                  context.width,
                                  VerifyBloc.get(context).image2, () {
                                VerifyBloc.get(context).removeImage(1);
                              }, () {
                                VerifyBloc.get(context)
                                    .selectFromGallery(context, 1);
                              }),
                            ),

                            const Row(
                              children: [
                                CustomText(
                                  text: Strings.acceptedpic,
                                  fontSize: Dimensions.smallFont,
                                  color: ColorManager.hintTextColor,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Row(
                              children: [
                                CustomText(
                                  text: Strings.ucClear,
                                  color: ColorManager.greyTextColor,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: CustomText(
                                    text: Strings.privPhoto,
                                    color: ColorManager.greyTextColor,
                                    align: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 80,
                            ),
                            //     if (state is VerifyLoading)
                            //       const SizedBox(child: LoadingCircle())
                            //     else if (state is VerifySuccess)
                            //       Text(
                            //         state.message,
                            //         style: const TextStyle(
                            //           color: Colors.green,
                            //           fontWeight: FontWeight.bold,
                            //         ),
                            //       )
                            //     else if (state is VerifyFailure)
                            //       Text(
                            //         state.message,
                            //         style: const TextStyle(
                            //           color: Colors.red,
                            //           fontWeight: FontWeight.bold,
                            //         ),
                            //       ),
                            state is VerifyLoading
                                ? const LoadingCircle()
                                : CustomButton(
                                    onTap: () {
                                      if (VerifyBloc.get(context).image1 !=
                                              null &&
                                          VerifyBloc.get(context).image2 !=
                                              null) {
                                        VerifyBloc.get(context)
                                            .add(Verification());
                                      } else {
                                        context.getSnackBar(
                                            snackText:
                                                'من فضلك ارفع الصور المطلوبة');
                                      }
                                    },
                                    text: Strings.congrats)
                          ],
                        ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
