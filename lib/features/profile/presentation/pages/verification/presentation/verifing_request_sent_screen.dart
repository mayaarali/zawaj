import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:zawaj/features/profile/presentation/bloc/states.dart';
import 'package:zawaj/features/setup_account/presentation/pages/rejectionPage.dart';
import 'package:zawaj/features/setup_account/presentation/pages/your_profile_is_complete.dart';

class VerificationRequestSent extends StatefulWidget {
  const VerificationRequestSent({super.key});

  @override
  State<VerificationRequestSent> createState() =>
      _VerificationRequestSentState();
}

class _VerificationRequestSentState extends State<VerificationRequestSent>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    log('return init');
    ProfileBloc.get(context).getMyProfile();
    String? verificationState =
        CacheHelper.getData(key: Strings.verificationState);
    if (verificationState == 'Accepted') {
      MagicRouter.navigateAndReplacement(const YourProfileIsComplete());
    }

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    //don't forget to dispose of it when not needed anymore
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    log('return lifecycle');
    log('${state == AppLifecycleState.resumed}');

    if (state == AppLifecycleState.resumed) {
      log('return backgroundg');
      await ProfileBloc.get(context).getMyProfile();
      String? verificationState =
          CacheHelper.getData(key: Strings.verificationState);
      log(verificationState.toString());
      if (verificationState == 'Accepted') {
        MagicRouter.navigateAndReplacement(const YourProfileIsComplete());
      }
      //now you know that your app went to the background and is back to the foreground
    }
    //register the last state. When you get "paused" it means the app went to the background.
  }

  Future<void> sendEmail() async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: 'zawaj48app@gmail.com',
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      print('............................Sending Mail Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return CustomScaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20),
            child: CustomButton(
                onTap: () {
                  ProfileBloc.get(context).getMyProfile();
                  String? verificationState =
                      CacheHelper.getData(key: Strings.verificationState);
                  if (verificationState == 'Accepted') {
                    MagicRouter.navigateAndReplacement(
                        const YourProfileIsComplete());
                  } else if (verificationState == 'Rejected') {
                    MagicRouter.navigateAndReplacement(
                        const YourProfileIsRejected());
                  }
                },
                text: Strings.contactwithadmin),
          ),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SvgPicture.asset(
                              ImageManager.heartLogo,
                              width: 120,
                              height: 80,
                            )),
                        const CustomText(
                          text: Strings.requestSent,
                          fontSize: Dimensions.largeFont,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const CustomText(
                          text: Strings.reviewRequst,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        const CustomText(
                          text: Strings.rejectionreason,
                          fontSize: Dimensions.smallFont,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () async {
                            sendEmail();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CustomText(
                                text: 'تواصل معنا',
                                fontSize: Dimensions.smallFont,
                                fontWeight: FontWeight.w800,
                                // textDecoration: TextDecoration.underline,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.mail_outline_rounded,
                                color: ColorManager.primaryColor,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
