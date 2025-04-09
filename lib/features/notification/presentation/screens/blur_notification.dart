import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/helper/profile_helper.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/custom_appbar.dart';
import 'package:zawaj/core/widgets/custom_button.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/core/widgets/loading_circle.dart';
import 'package:zawaj/features/home/data/models/home_model.dart';
import 'package:zawaj/features/notification/presentation/allNotificationBloc/all_notification_bloc.dart';
import 'package:zawaj/features/notification/presentation/screens/empty_notification.dart';
import 'package:zawaj/features/notification/presentation/screens/likes_notification_page.dart';
import 'package:zawaj/features/notification/presentation/whoLikedMe_bloc/who_like_me_bloc.dart';
import 'package:zawaj/features/notification/presentation/widgets/notificationBodyWidget.dart';
import 'package:zawaj/features/payment/presentation/pages/choose_bundle_screen.dart';
import 'package:zawaj/features/profile/presentation/bloc/profile_bloc.dart';

class BlurNotification extends StatefulWidget {
  const BlurNotification({super.key});

  @override
  State<BlurNotification> createState() => _BlurNotificationState();
}

class _BlurNotificationState extends State<BlurNotification> {
  // bool isSubscribed = false;

  @override
  void initState() {
    super.initState();
    final whoLikeMeBloc = BlocProvider.of<WhoLikeMeBloc>(context);
    whoLikeMeBloc.add(WhoLikedEvent());
    BlocProvider.of<AllNotificationBloc>(context).add(AllNotificationEvent());
    ProfileBloc.get(context).getMyProfile();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ProfileHelper.checkVerificationAndSubscription(context);
    });
    //_loadSubscriptionStatus();
  }

  // Future<void> _loadSubscriptionStatus() async {
  //   final subscriptionStatus =
  //       await CacheHelper.getData(key: Strings.isSubscribed) ?? false;
  //   setState(() {
  //     isSubscribed = subscriptionStatus;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isFullScreen: true,
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const CustomAppBar(
            title: Strings.notification,
            isBack: false,
            leading: MenuButton(),
            // isMenuIcon: true,
          ),
          const SizedBox(
            height: 20,
          ),
          // ProfileBloc.get(context).profileData!.isSubscribed == true
          //     ?
          // const Center(
          //         child: CustomText(
          //           text: 'الأشخاص الذين أعجبوا بك',
          //           fontSize: 20,
          //         ),
          //       )
          //     : const SizedBox(),
          // const SizedBox(
          //   height: 20,
          // ),

          BlocConsumer<WhoLikeMeBloc, WhoLikeMeState>(
            listener: (context, state) {},
            builder: (context, state) => state is WhoLikeMeLoading
                ? const LoadingCircle()
                : state is WhoLikeMeSuccess
                    ? state.homeModel.isEmpty
                        ? const EmptyNotification()
                        : Column(
                            children: [
                              Center(
                                child: CustomText(
                                  text: 'الأشخاص الذين أعجبوا بك',
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisSpacing: 20,
                                          crossAxisCount: 2,
                                          childAspectRatio: 20 / 27,
                                          mainAxisSpacing:
                                              context.height * 0.03),
                                  shrinkWrap: true,
                                  itemCount: state.homeModel.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (ProfileBloc.get(context)
                                            .profileData
                                            ?.isSubscribed ??
                                        false) {
                                      return WhoLikedMeList(
                                          homeModel: state.homeModel[index]);
                                    } else {
                                      return WhoLikedBlured(
                                              homeModel: state.homeModel[index])
                                          .blurred(
                                        colorOpacity: 0.1,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          )
                    : const SizedBox(),
          ),

          BlocConsumer<AllNotificationBloc, WhoLikeMeState>(
            listener: (context, state) {},
            builder: (context, state) => state is AllNotificationLoading
                ? const SizedBox()
                : state is AllNotificationSuccess
                    ? state.notificationModel.isEmpty
                        ? const SizedBox()
                        : Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),

                                // BorderRadius.circular(
                                //     Dimensions.buttonRadius),
                                border: Border.all(
                                  color: ColorManager.primaryColor,
                                )),
                            child: Column(
                              children: [
                                const Row(
                                  children: [
                                    CustomText(
                                      text: Strings.otherNotification,
                                      fontSize: 20,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: state.notificationModel.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return NotificationBody(
                                        notificationModel:
                                            state.notificationModel[index],
                                      );
                                    }),
                              ],
                            ),
                          )
                    : const SizedBox(),
          ),
          const SizedBox(
            height: 70,
          ),
          ProfileBloc.get(context).profileData!.isSubscribed == false
              ? const CustomText(
                  text: Strings.wholikesyou,
                  fontSize: 20,
                )
              : const SizedBox(),
          const SizedBox(
            height: 30,
          ),
          ProfileBloc.get(context).profileData!.isSubscribed == false
              ? CustomButton(
                  onTap: () {
                    MagicRouter.navigateTo(
                        //    const LikeNotificationPage()
                        ChooseBundle(
                      userId: ProfileBloc.get(context).profileData!.userId!,
                      isFromProfileScreen: true,
                    ));
                  },
                  text: Strings.gopaymentbutton,
                )
              : const SizedBox(),
          // const SizedBox(height: 100),
        ]),
      ),
    );
  }
}

class WhoLikedBlured extends StatelessWidget {
  const WhoLikedBlured({super.key, required this.homeModel});
  final HomeModel homeModel;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 20,
      children: [
        Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                  EndPoints.BASE_URL_image + homeModel.images![0],
                  width: context.width * 0.40,
                  height: context.height * 0.2,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                return const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Icon(Icons.error)),
                  ],
                );
              }, frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                return child;
              }, loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return const Center(
                    child: LoadingCircle(),
                  );
                }
              }),
            ),
          ],
        ),
      ],
    );
  }
}
