import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/validator/validator.dart';
import 'package:zawaj/core/widgets/custom_appbar.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/core/widgets/custom_text_field.dart';
import 'package:zawaj/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:zawaj/features/authentication/presentation/bloc/auth_event.dart';
import 'package:zawaj/features/authentication/presentation/bloc/auth_states.dart';
import 'package:zawaj/features/authentication/presentation/pages/login_signup/login_page.dart';
import 'package:zawaj/features/authentication/presentation/pages/otp/phone_no_verify.dart';

class EnterPhoneAndName extends StatelessWidget {
  const EnterPhoneAndName({super.key});
  static final GlobalKey<FormState> nameFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CustomScaffold(
        isFullScreen: true,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                  onTap: () {
                    if (nameFormKey.currentState!.validate()) {
                      if (AuthBloc.get(context).isLoading == false) {
                        AuthBloc.get(context).add(CompleteRegister());
                      }
                    }
                  },
                  text: Strings.next),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                child: CustomText(
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
                  MagicRouter.navigateAndPopAll(LoginPage());
                },
              )
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomAppBar(
                isBack: false,
              ),
              Center(
                child: BlocConsumer<AuthBloc, AuthStates>(
                  listener: (context, state) {
                    if (state is CompleteRegisterSuccess) {
                      MagicRouter.navigateAndPopAll(const PhoneVerify());
                    } else if (state is CompleteRegisterFailed) {
                      context.getSnackBar(
                          snackText: state.message, isError: true);
                    }
                  },
                  builder: (context, state) {
                    return Form(
                      key: nameFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(50.0),
                            child: Image.asset(ImageManager.logo),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const CustomText(
                            text: Strings.pleaseEnterDetails,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomTextField(
                            hintText: Strings.name,
                            keyboardType: TextInputType.name,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[a-zA-Z\u0621-\u064a-\ ]")),
                            ],
                            controller: AuthBloc.get(context).nameController,
                            validate: (v) => Validator.isNameValid(v),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomTextField(
                            hintText: Strings.phone_no,
                            keyboardType: TextInputType.phone,
                            controller: AuthBloc.get(context).phoneController,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
