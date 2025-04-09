import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/core/helper/profile_helper.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/custom_appbar.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/core/widgets/loading_circle.dart';
import 'package:zawaj/features/chat/data/data_source/chat_messages_dataSource.dart';
import 'package:zawaj/features/chat/data/repos/chat_message_repository.dart';
import 'package:zawaj/features/chat/domain/get_chat_messages_usecase.dart';
import 'package:zawaj/features/chat/presentation/chat_message_cubit/chat_messages_cubit.dart';
import 'package:zawaj/features/chat/presentation/screens/chat_screen.dart';
import 'package:zawaj/features/home/data/models/home_model.dart';
import 'package:zawaj/features/home/presentation/pages/partner_details_screen.dart';
import 'package:zawaj/features/notification/presentation/screens/empty_notification.dart';
import 'package:zawaj/features/notification/presentation/whoLikedMe_bloc/who_like_me_bloc.dart';
import 'package:zawaj/features/profile/presentation/bloc/profile_bloc.dart';

class LikeNotificationPage extends StatefulWidget {
  const LikeNotificationPage({super.key});

  @override
  State<LikeNotificationPage> createState() => _LikeNotificationPageState();
}

class _LikeNotificationPageState extends State<LikeNotificationPage> {
  @override
  void initState() {
    super.initState();
    final whoLikeMeBloc = BlocProvider.of<WhoLikeMeBloc>(context);
    whoLikeMeBloc.add(WhoLikedEvent());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ProfileHelper.checkVerificationAndSubscription(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        isFullScreen: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomAppBar(
              title: Strings.notification,
              isBack: true,
            ),
            const SizedBox(
              height: 20,
            ),
            BlocConsumer<WhoLikeMeBloc, WhoLikeMeState>(
              listener: (context, state) {},
              builder: (context, state) => state is WhoLikeMeLoading
                  ? const LoadingCircle()
                  : state is WhoLikeMeSuccess
                      ? state.homeModel.isEmpty
                          ? const EmptyNotification()
                          : Container(
                              color: Colors.red,
                              height: context.height,
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing: 20,
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 50),
                                shrinkWrap: true,
                                itemCount: state.homeModel.length,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return WhoLikedMeList(
                                    homeModel: state.homeModel[index],
                                  );
                                },
                              ),
                            )
                      : const SizedBox(),
              // ),
            )
          ],
        ));
  }
}

class WhoLikedMeList extends StatelessWidget {
  WhoLikedMeList({super.key, required this.homeModel});
  final HomeModel homeModel;

  @override
  Widget build(BuildContext context) {
    final hasChat = ProfileBloc.get(context).profileData?.hasChat;
    final chatUserId = ProfileBloc.get(context).profileData?.chatUserId;
    final isSubscribed = ProfileBloc.get(context).profileData?.isSubscribed;

    return Wrap(
      spacing: 12,
      runSpacing: 20,
      direction: Axis.horizontal,
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: () {
                MagicRouter.navigateTo(
                    PartnerDetailsScreen(homeModel: homeModel));
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                        EndPoints.BASE_URL_image + homeModel.images![0],
                        width: context.width * 0.40,
                        height: context.height * 0.2,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        ImageManager.profileError,
                        width: context.width * 0.40,
                        height: context.height * 0.13,
                      );
                    }, frameBuilder:
                            (context, child, frame, wasSynchronouslyLoaded) {
                      return child;
                    }, loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: context.width * 0.40,
                            height: context.height * 0.2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        );
                      }
                    }),
                  ),
                  ProfileBloc.get(context).profileData!.isSubscribed == false
                      ? const SizedBox()
                      : IconButton(
                          onPressed: () {
                            if ((isSubscribed == true && hasChat == 0) ||
                                (isSubscribed == true &&
                                    hasChat == 1 &&
                                    homeModel.userId == chatUserId)) {
                              MagicRouter.navigateTo(BlocProvider(
                                create: (context) => ChatMessagesCubit(
                                    GetChatMessagesDataUseCase(
                                        ChatMessagesRepositoryImpl(
                                            ChatDataProvider())))
                                  ..getChatMessagesData(
                                      homeModel.userId.toString()),
                                child: ChatScreen(
                                  receiverProdileImage:
                                      EndPoints.BASE_URL_image +
                                          homeModel.images![0],
                                  receiverId: homeModel.userId!,
                                  homeModel: homeModel,
                                  receiverName: homeModel.name!,
                                ),
                              ));
                            } else if (hasChat == 1) {
                              context.getSnackBar(
                                  snackText:
                                      'يجب عليك أنهاء الدردشة الحالية أولا',
                                  isError: true);
                            } else {
                              context.getSnackBar(
                                  snackText: 'يجب عليك الاشتراك اولا',
                                  isError: true);
                            }
                          },
                          icon: SvgPicture.asset(ImageManager.chat,
                              color: Colors.white,
                              width: context.width * 0.05,
                              height: context.width * 0.05)),
                ],
              ),
            ),
            CustomText(
              text: homeModel.name ?? "",
              textOverFlow: TextOverflow.ellipsis,
            ),
            CustomText(text: homeModel.age.toString() ?? ""),
          ],
        ),
      ],
    );
  }
}
