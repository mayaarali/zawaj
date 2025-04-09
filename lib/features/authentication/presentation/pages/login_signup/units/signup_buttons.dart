part of '../signup_page.dart';

class SignUpButtons extends StatelessWidget {
  const SignUpButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomText(
                text: Strings.have_account,
                fontSize: Dimensions.normalFont,
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                  onTap: () {
                    MagicRouter.navigateAndReplacement(const LoginPage());
                  },
                  child: const CustomText(
                    text: Strings.login,
                    fontSize: Dimensions.normalFont,
                    textDecoration: TextDecoration.underline,
                  )),
            ],
          ),
          onTap: () {
            MagicRouter.navigateAndReplacement(const LoginPage());
          },
        ),
      ],
    );
  }
}

class SocialMediaSignupButtons extends StatelessWidget {
  const SocialMediaSignupButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          height: 20,
        ),
        GoogleLogin(),
        SizedBox(
          height: 5,
        ),
        FaceBookLogin(),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
