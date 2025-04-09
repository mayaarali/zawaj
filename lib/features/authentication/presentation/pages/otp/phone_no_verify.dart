import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
import 'package:zawaj/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:zawaj/features/authentication/presentation/bloc/auth_event.dart';
import 'package:zawaj/features/authentication/presentation/bloc/auth_states.dart';
import 'package:zawaj/features/authentication/presentation/pages/login_signup/signup_success_screen.dart';
import 'package:zawaj/features/authentication/presentation/pages/otp/enter_name_phone_Screen.dart';
import 'package:zawaj/features/authentication/presentation/widgets/pin_code_widgets.dart';
import 'package:zawaj/features/resend_email_otp/data/datasource/resend_email_otp_remote_datasource.dart';
import 'package:zawaj/features/resend_email_otp/domain/use_cases/resend_email_otp_usecase.dart';

import '../../../../resend_email_otp/data/repository_impl/resend_email_otp_repository_impl.dart';
import '../../../../resend_email_otp/presentation/logic/resend_email_otp_cubit.dart';

class PhoneVerify extends StatefulWidget {
  const PhoneVerify({super.key});

  @override
  State<PhoneVerify> createState() => _PhoneVerifyState();
}

class _PhoneVerifyState extends State<PhoneVerify> {
  Timer? _timer;
  int _start = 120;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  String getFormattedTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthStates>(
      listener: (context, state) {
        if (state is SendPhoneSuccess) {
          MagicRouter.navigateAndPopAll(SignupSuccess());
        } else if (state is SendPhoneFailed) {
          context.getSnackBar(snackText: state.message, isError: true);
        }
      },
      builder: (context, state) {
        return CustomScaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      AuthBloc.get(context).phoneController.clear();
                      AuthBloc.get(context).nameController.clear();
                      MagicRouter.navigateAndReplacement(
                          const EnterPhoneAndName());
                    },
                    child: const CustomText(
                      text: Strings.changePhoneNo,
                      textDecoration: TextDecoration.underline,
                    ))
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.defaultPadding),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CustomAppBar(
                    isBack: false,
                    isLogoTitle: true,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const CustomText(
                    text: Strings.enterPhonOtp,
                    align: TextAlign.center,
                    fontSize: Dimensions.largeFont,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const CustomText(
                    text: Strings.send_msg_to_you,
                    align: TextAlign.center,
                    fontSize: Dimensions.normalFont,
                    fontWeight: FontWeight.w600,
                    color: ColorManager.greyTextColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomText(
                    text: AuthBloc.get(context).phoneController.text,
                    align: TextAlign.center,
                    fontSize: Dimensions.normalFont,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.greyTextColor,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const CustomText(
                    text: Strings.enter_otp,
                    align: TextAlign.center,
                    fontSize: Dimensions.smallFont,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.greyTextColor,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: PinCodeWidget(
                      controller:
                          AuthBloc.get(context).verifyPhoneOtpController,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomButton(
                      onTap: () {
                        final otpController =
                            AuthBloc.get(context).verifyPhoneOtpController;
                        if (otpController.text.isNotEmpty) {
                          AuthBloc.get(context).add(ConfirmPhone());
                        } else {
                          context.getSnackBar(
                              snackText: 'ادخل رمز التحقق', isError: true);
                        }
                        //  MagicRouter.navigateTo(SignupSuccess());
                      },
                      text: Strings.confirm),
                  const SizedBox(
                    height: 10,
                  ),
                  _start > 0
                      ? Row(
                          children: [
                            const Text(
                              "إعادة ارسال الكود بعد  ",
                              style:
                                  TextStyle(color: ColorManager.greyTextColor),
                            ),
                            CustomText(
                              text: getFormattedTime(_start),
                              fontWeight: FontWeight.bold,
                            )
                          ],
                        )
                      : BlocProvider(
                          create: (context) => ResendEmailOtpCubit(
                              ResendEmailOtpUseCase(ResendEmailOtpRepositoryImpl(
                                  remoteDataSource:
                                      ResendEmailOtpRemoteDataSourceImpl(
                                          dio: Dio(),
                                          remoteDataSource:
                                              ResendEmailOtpRemoteDataSource,
                                          isEmailOtp: false)))),
                          child: BlocBuilder<ResendEmailOtpCubit,
                              ResendEmailOtpState>(
                            builder: (context, state) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    child: const CustomText(
                                      text: Strings.resend_otp,
                                      color: ColorManager.greyTextColor,
                                      textDecoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    onTap: () {
                                      context
                                          .read<ResendEmailOtpCubit>()
                                          .resendOtpCubit();
                                      startTimer();
                                      setState(() {
                                        _start = 120;
                                      });
                                    },
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
