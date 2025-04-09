import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/validator/validator.dart';
import 'package:zawaj/core/widgets/custom_appbar.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text_field.dart';
import 'package:zawaj/core/widgets/loading_circle.dart';
import 'package:zawaj/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:zawaj/features/authentication/presentation/bloc/auth_event.dart';
import 'package:zawaj/features/authentication/presentation/bloc/auth_states.dart';
import 'package:zawaj/features/authentication/presentation/pages/login_signup/login_page.dart';
import 'package:zawaj/features/authentication/presentation/pages/new_password/success_new_password.dart';
import 'package:zawaj/features/authentication/presentation/pages/otp/otp_page.dart';
import '../../../../../core/widgets/custom_text.dart';

class ReEnterPasswordPage extends StatefulWidget {
  const ReEnterPasswordPage({super.key});

  @override
  State<ReEnterPasswordPage> createState() => _ReEnterPasswordPageState();
}

class _ReEnterPasswordPageState extends State<ReEnterPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        isFullScreen: true,
        child: SingleChildScrollView(
          child: BlocConsumer<AuthBloc, AuthStates>(
            listener: (context, state) {
              if (state is ResetPasswordSuccess) {
                context.getSnackBar(snackText: ' تم تغيير كلمة المرور بنجاح');
                MagicRouter.goBack();
              } else if (state is ResetPasswordFailed) {
                context.getSnackBar(
                  snackText: state.message,
                  isError: true,
                );
              } else if (state is ResetPasswordLoadingAuth) {
                const LoadingCircle();
              }
            },
            builder: (context, state) {
              AuthBloc authBloc = AuthBloc.get(context);

              // Update the colors
              Color firstContainerColor = authBloc.firstContainerColor;
              Color secondContainerColor = authBloc.secondContainerColor;
              Color thirdContainerColor = authBloc.thirdContainerColor;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppBar(
                    backgroundColor: Colors.white,
                    actions: [
                      IconButton(
                          onPressed: () {
                            MagicRouter.goBack();
                            //   MagicRouter.navigateTo(OTPPage());
                            //Navigator.pop(context);
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (_) => OTPPage(),
                            //     ),
                            //   );
                          },
                          icon: Icon(Icons.arrow_forward,
                              color: ColorManager.hintTextColor)),
                    ],
                    leading: SizedBox(),
                    title: CustomText(
                      text: Strings.new_pass,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: CustomTextField(
                      hintText: Strings.password,
                      controller: AuthBloc.get(context).resetPassController,
                      validate: (v) => Validator.validateEmpty(v),
                      obscure: AuthBloc.get(context).isSecure ? true : false,
                      suffixIcon: IconButton(
                        icon: Icon(
                          !AuthBloc.get(context).isSecure
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 20,
                        ),
                        onPressed: () {
                          AuthBloc.get(context).getSecure();
                        },
                      ),
                      onChanged: (value) {
                        setState(() {
                          AuthBloc.get(context).resetPassowrdValidation(value);
                          AuthBloc.get(context).setColor(value);
                        });
                        AuthBloc.get(context).resetPassowrdValidation(value);
                        print(value);
                        print(AuthBloc.get(context)
                            .resetPassowrdValidation(value));
                        print("////////");
                        print(value);
                        AuthBloc.get(context).setColor(value);
                        AuthBloc.get(context).resetPassowrdValidation(value);
                        print(value);
                        print(AuthBloc.get(context)
                            .resetPassowrdValidation(value));
                        AuthBloc.get(context).setColor(value);
                      },
                    ),
                  ),
                  const CustomText(
                    lines: 2,
                    text: Strings.validation_password,
                    align: TextAlign.start,
                    fontSize: Dimensions.smallFont,
                    // textOverFlow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 5,
                        //  color: Colors.black38,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: firstContainerColor,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 100,
                        height: 5,
                        //  color: Colors.black38,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: secondContainerColor,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 100,
                        height: 5,
                        //  color: Colors.black38,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: thirdContainerColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  CustomButton(
                      onTap: () {
                        //  AuthBloc.get(context).add(ResetPasswordEvent());
                        final resetPassController =
                            AuthBloc.get(context).resetPassController;
                        final msg = AuthBloc.get(context)
                            .resetPassowrdValidation(resetPassController.text);
                        if (msg == 'success') {
                          AuthBloc.get(context).add(ResetPasswordEvent());
                        } else {
                          context.getSnackBar(
                              isError: true,
                              snackText: "من فضلك اكتب كلمة مرور معقدة");
                        }
                      },
                      text: Strings.re_enter_pass)
                ],
              );
            },
          ),
        ));
  }
}
