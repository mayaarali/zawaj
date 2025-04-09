part of '../signup_page.dart';

class SignUpForms extends StatelessWidget {
  const SignUpForms({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthStates>(
      listener: (BuildContext context, AuthStates state) {},
      builder: (BuildContext context, AuthStates state) => Column(
        children: [
          const Row(
            children: [],
          ),
          const SizedBox(
            height: 20,
          ),
          // CustomTextField(
          //   hintText: Strings.person_name,
          //   controller: AuthBloc.get(context).nameController,
          //   validate: (v) => Validator.validateName(v),
          // ),
          // const SizedBox(
          //   height: 15,
          // ),
          // CustomTextField(
          //   hintText: Strings.phone_no,
          //   controller: AuthBloc.get(context).phoneController,
          //   validate: (v) => Validator.validatePhone(v),
          // ),
          // const SizedBox(
          //   height: 15,
          // ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                text: Strings.email,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: CustomTextField(
              hintText: Strings.email,
              controller: AuthBloc.get(context).emailController,
              validate: (v) => Validator.validateEmail(v),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                text: Strings.password,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: CustomTextField(
                hintText: Strings.enterPassword,
                controller: AuthBloc.get(context).passwordController,
                validate: (v) => Validator.validateEmpty(v),
                obscure: AuthBloc.get(context).isSecure ? true : false,
                suffixIcon: GestureDetector(
                  child: SvgPicture.asset(
                    !AuthBloc.get(context).isSecure
                        ? ImageManager.visible
                        : ImageManager.nonVisible,
                    fit: BoxFit.scaleDown,
                  ),
                  onTap: () {
                    AuthBloc.get(context).getSecure();
                  },
                )),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                text: Strings.caracter_password,
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          // CustomTextField(
          //     hintText: Strings.password_again,
          //     validate: (v) => Validator.validateConfirmPass(
          //         AuthBloc.get(context).passwordController.text, v),
          //     obscure: AuthBloc.get(context).isSecure ? true : false,
          //     suffixIcon: GestureDetector(
          //       child: SvgPicture.asset(
          //         !AuthBloc.get(context).isSecure
          //             ? ImageManager.visible
          //             : ImageManager.nonVisible,
          //         fit: BoxFit.scaleDown,
          //       ),
          //       onTap: () {
          //         AuthBloc.get(context).getSecure();
          //       },
          //     )

          //     // suffixIcon: InkWell(
          //     // onTap: () {
          //     // AuthBloc.get(context).getSecure();
          //     // },
          //     // child: Icon(!AuthBloc.get(context).isSecure
          //     // ? Icons.visibility
          //     //     : Icons.visibility_off)),

          //     ,
          //     controller: AuthBloc.get(context).confirmPassController),
          // const SizedBox(
          //  height: 10,
          // ),
          state is AuthFailed
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomText(
                        text: state.message,
                        color: Colors.red,
                        align: TextAlign.start,
                      ),
                      SizedBox(
                        width: context.width * 0.01,
                      ),
                      state.message == 'يجب ادخال كلمة مرور معقدة'
                          ? IconButton(
                              onPressed: () {
                                context.getSnackBar(
                                  snackText:
                                      'تأكد من أن كلمة المرور معقدة وتحتوي على مزيج من الأحرف الكبيرة والصغيرة، والأرقام، والرموز مثل @ أو !',
                                  isError: true,
                                );
                              },
                              icon: const Icon(
                                Icons.info_outline,
                                color: ColorManager.primaryColor,
                              ))
                          : const SizedBox(),
                    ],
                  ),
                )
              : const SizedBox(),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
