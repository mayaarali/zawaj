import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:zawaj/core/widgets/toast.dart';
import 'package:zawaj/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:zawaj/features/authentication/presentation/bloc/auth_event.dart';
import 'package:zawaj/features/authentication/presentation/bloc/auth_states.dart';

import '../../../../../core/widgets/custom_text.dart';
import 'check_email.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthStates>(
      listener: (context, state) {
        if (state is LoadingAuth) {
          const Center(child: LoadingCircle());
        } else if (state is SendEmailSuccess) {
          MagicRouter.navigateTo(const CheckEmailPage());

          showToast(msg: Strings.checkEmail);
        } else if (state is SendEmailFailed) {
          context.getSnackBar(
            snackText: state.message,
            isError: true,
          );
          /*   showToast(
                          msg: state.message,
                          background: ColorManager.primaryColor,
                          textColor: ColorManager.secondaryPinkColor,
                          gravity: ToastGravity.BOTTOM);
                          */
        }
      },
      builder: (context, state) {
        return CustomScaffold(
            child: Padding(
          padding: const EdgeInsets.all(Dimensions.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const CustomAppBar(
                title: Strings.re_enter_pass,
              ),
              const SizedBox(
                height: 50,
              ),
              const CustomText(
                text: Strings.enter_email_send_link,
                align: TextAlign.start,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: CustomTextField(
                  hintText: Strings.email_address,
                  validate: (v) => Validator.validateEmail(v),
                  controller: AuthBloc.get(context).confirmationEmailController,
                ),
              ),
              state is LoadingAuth
                  ? const LoadingCircle()
                  : CustomButton(
                      onTap: () {
                        print("///////////");

                        print(
                            AuthBloc.get(context).confirmationEmailController);
                        AuthBloc.get(context).add(SendEmailEvent());
                      },
                      text: Strings.send_link)
            ],
          ),
        ));
      },
    );
  }
}
