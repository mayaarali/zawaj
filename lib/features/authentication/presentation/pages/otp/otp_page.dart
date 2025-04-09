import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/custom_appbar.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:zawaj/features/authentication/presentation/bloc/auth_event.dart';
import 'package:zawaj/features/authentication/presentation/bloc/auth_states.dart';
import 'package:zawaj/features/authentication/presentation/pages/new_password/reenter_password.dart';

import '../../../../../core/widgets/custom_text.dart';
import '../../widgets/pin_code_widgets.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  // @override
  // void initState() {
  //   AuthBloc.get(context).oTPController.clear();
  //   super.initState();
  // }
  int _countdown = 120;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    AuthBloc.get(context).oTPController.clear();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthStates>(
      listener: (context, state) {
        if (state is CheckOTPSuccess) {
          MagicRouter.navigateAndPopUntilFirstPage(const ReEnterPasswordPage());
        } else if (state is CheckOTPFailed) {
          print('staate otp failed');
          // context.getSnackBar(snackText: ' رمز التحقق خاطئ ', isError: true);
        }
      },
      builder: (context, state) {
        return CustomScaffold(
            child: Padding(
          padding: const EdgeInsets.all(Dimensions.defaultPadding),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CustomAppBar(
                  title: Strings.enter_otp,
                ),
                const SizedBox(
                  height: 50,
                ),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomText(
                      text: Strings.enter_otp_from_email,
                      align: TextAlign.start,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: PinCodeWidget(
                    controller: AuthBloc.get(context).oTPController,
                  ),
                ),

                CustomButton(
                    onTap: () {
                      final otpController = AuthBloc.get(context).oTPController;

                      if (otpController.text.isNotEmpty) {
                        AuthBloc.get(context).add(CheckOtpEvent());
                        // MagicRouter.navigateAndPopUntilFirstPage(
                        //     ReEnterPasswordPage());
                      }
                      if (otpController.text.isEmpty) {
                        context.getSnackBar(
                            snackText: 'من فضلك ادخل رمز التحقق',
                            isError: true);
                      }
                    },
                    text: Strings.next),
                //  const SizedBox(height: context.height*0.1,),
                const SizedBox(
                  height: 30,
                ),
                state is LoadingAuth
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          if (state is CheckOTPFailed)
                            const Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: CustomText(
                                text: 'رمز التحقق خاطئ',
                                align: TextAlign.center,
                                color: Colors.red,
                              ),
                            ),
                          GestureDetector(
                            onTap: _countdown == 0
                                ? () {
                                    AuthBloc.get(context).add(SendEmailEvent());
                                    setState(() {
                                      _countdown = 120;
                                      _startTimer();
                                    });
                                  }
                                : null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: state is CheckOTPFailed
                                      ? 'اعاده مره اخري'
                                      : (_countdown > 0
                                          ? 'اعاده ارسال الكود خلال $_countdown ثانيه'
                                          : Strings.dont_receive_code),
                                  align: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
              ],
            ),
          ),
        ));
      },
    );
  }
}
