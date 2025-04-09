part of '../login_page.dart';

class LoginButtons extends StatelessWidget {
  const LoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          height: 20,
        ),
        GoogleLogin(),
        SizedBox(
          height: 8,
        ),
        FaceBookLogin(),
        SizedBox(
          height: 10,
        ),
//    InkWell(
//      onTap: (){
//        MagicRouter.navigateTo(const EnterPhonePage());
//      },
//      child: const Row(
//        mainAxisAlignment: MainAxisAlignment.start,
//        children: [
//    CustomText(text: Strings.continue_with_phone,fontSize: Dimensions.normalFont,),
//        ],
//      ),
//    ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
