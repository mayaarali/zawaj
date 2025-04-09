part of '../login_page.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthStates>(
      listener: (BuildContext context, AuthStates state) {},
      builder: (BuildContext context, AuthStates state) => Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          CustomTextField(
            hintText: Strings.email,
            controller: AuthBloc.get(context).emailController,
            validate: (v) => Validator.validateEmail(v),
          ),
          const SizedBox(
            height: 15,
          ),
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
                    ],
                  ),
                )
              : const SizedBox(),
          CustomTextField(
            hintText: Strings.password,
            obscure: AuthBloc.get(context).isSecure ? true : false,
            /* suffixIcon: InkWell(
                onTap: () {
                  AuthBloc.get(context).getSecure();
                },
                child: Icon(
                  !AuthBloc.get(context).isSecure
                      ? Icons.visibility
                      : Icons.visibility_off,
                  size: 20,
                )),
                */
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
            ),
            controller: AuthBloc.get(context).passwordController,
            validate: (v) => Validator.validateEmpty(v),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
