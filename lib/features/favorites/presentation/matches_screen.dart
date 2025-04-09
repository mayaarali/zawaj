import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/core/helper/profile_helper.dart';
import 'package:zawaj/core/widgets/build_dialog.dart';
import 'package:zawaj/core/widgets/custom_appbar.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/core/widgets/loading_circle.dart';
import 'package:zawaj/core/widgets/loading_popup.dart';
import 'package:zawaj/features/chat/data/data_source/chat_messages_dataSource.dart';
import 'package:zawaj/features/chat/data/repos/chat_message_repository.dart';
import 'package:zawaj/features/chat/domain/get_chat_messages_usecase.dart';
import 'package:zawaj/features/chat/presentation/chat_message_cubit/chat_messages_cubit.dart';
import 'package:zawaj/features/chat/presentation/screens/chat_screen.dart';
import 'package:zawaj/features/favorites/presentation/bloc/favorites_post_bloc.dart';
import 'package:zawaj/features/home/data/models/home_model.dart';
import 'package:zawaj/features/home/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:zawaj/features/home/presentation/blocs/likedPost_bloc/liked_post_bloc.dart';
import 'package:zawaj/features/home/presentation/pages/partner_details_screen.dart';
import 'package:zawaj/features/profile/presentation/bloc/profile_bloc.dart';
import '../../../core/constants/color_manager.dart';
import '../../../core/router/routes.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  late ScrollController _scrollController;
  late LikedPartnersBloc likedPartnersBloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ProfileHelper.checkVerificationAndSubscription(context);
    });
    likedPartnersBloc = BlocProvider.of<LikedPartnersBloc>(context);
    BlocProvider.of<HomeBloc>(context).getHomeData();
    likedPartnersBloc.add(LoadLikedPartnersEvent(1));

    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          likedPartnersBloc.loadMore();
        }
        if (_scrollController.position.pixels ==
            _scrollController.position.minScrollExtent) {
          likedPartnersBloc.loadPrevious();
        }
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isFullScreen: true,
      child: Column(
        children: [
          const CustomAppBar(
            isBack: false,
            isHeartTitle: true,
          ),
          BlocConsumer<LikedPartnersBloc, LikedPartnersStates>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is LikedPartnersLoading &&
                  LikedPartnersBloc.get(context).homeModel.isEmpty) {
                return const LoadingPopUp();
              } else if (state is LikedPartnersSuccess ||
                  LikedPartnersBloc.get(context).homeModel.isNotEmpty) {
                log("state.homeModel.length.toString()");
                log(LikedPartnersBloc.get(context).homeModel.length.toString());
                return LikedPartnersBloc.get(context).homeModel.isEmpty
                    ? const Expanded(
                        child:
                            Center(child: CustomText(text: Strings.noLikesyet)),
                      )
                    : Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: LikedPartnersBloc.get(context)
                                    .homeModel
                                    .length,
                                itemBuilder: (BuildContext context, int index) {
                                  return LikedPostWidget(
                                    homeModel: LikedPartnersBloc.get(context)
                                        .homeModel[index],
                                    onRemoveUser: (removedUser) {
                                      setState(() {
                                        LikedPartnersBloc.get(context)
                                            .homeModel
                                            .removeWhere((user) =>
                                                user.userId.toString() ==
                                                removedUser.userId);
                                      });
                                    },
                                  );
                                },
                              ),
                              if (state is LikedPartnersLoading)
                                const LinearProgressIndicator(
                                  color: ColorManager.primaryColor,
                                ),
                            ],
                          ),
                        ),
                      );
              } else {
                return const SizedBox(height: 100, width: 100);
              }
            },
          ),
        ],
      ),
    );
  }
}

class LikedPostWidget extends StatefulWidget {
  LikedPostWidget({
    super.key,
    required this.homeModel,
    required this.onRemoveUser,
  });
  final HomeModel homeModel;
  final Function(HomeModel) onRemoveUser;

  @override
  State<LikedPostWidget> createState() => _LikedPostWidgetState();
}

class _LikedPostWidgetState extends State<LikedPostWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GestureDetector(
                  onTap: () {
                    MagicRouter.navigateTo(
                        PartnerDetailsScreen(homeModel: widget.homeModel));
                  },
                  child: Image.network(
                      widget.homeModel.images != null &&
                              widget.homeModel.images!.isNotEmpty
                          ? (EndPoints.BASE_URL_image +
                              widget.homeModel.images![0])
                          : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
                      width: context.width,
                      height: context.height * 0.5,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.white,
                      width: context.width,
                      height: context.height * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Image.asset(
                              ImageManager.profileError,
                            ),
                          ),
                        ],
                      ),
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
                          width: context.width,
                          height: context.height * 0.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      );
                    }
                  })),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Card(
                    color: Colors.white.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    child: GestureDetector(
                      onTap: () {
                        buildDialog(
                            context: context,
                            onTapEnter: () {
                              BlocProvider.of<LikedPostBloc>(context).add(
                                RemoveUserEvent(
                                    userId: widget.homeModel.id.toString()),
                              );
                              widget.onRemoveUser(widget.homeModel);

                              Navigator.pop(context);
                            },
                            buttonTitle: Strings.yes,
                            title: Strings.dismiss,
                            desc: Strings.dismiss_confirm);
                      },
                      child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: ColorManager.primaryColor, width: 1),
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.5)),
                          child: SvgPicture.asset(
                            ImageManager.closeIcon,
                            color: ColorManager.primaryColor,
                            width: 14,
                            height: 14,
                            fit: BoxFit.scaleDown,
                          )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      final isSubscribed =
                          ProfileBloc.get(context).profileData?.isSubscribed;
                      final hasChat =
                          ProfileBloc.get(context).profileData?.hasChat;
                      final chatUserId =
                          ProfileBloc.get(context).profileData?.chatUserId;

                      if ((isSubscribed == true && hasChat == 0) ||
                          (isSubscribed == true &&
                              hasChat == 1 &&
                              widget.homeModel.userId == chatUserId)) {
                        MagicRouter.navigateTo(BlocProvider(
                          create: (context) => ChatMessagesCubit(
                              GetChatMessagesDataUseCase(
                                  ChatMessagesRepositoryImpl(
                                      ChatDataProvider())))
                            ..getChatMessagesData(
                                widget.homeModel.userId.toString()),
                          child: ChatScreen(
                            receiverProdileImage: EndPoints.BASE_URL_image +
                                widget.homeModel.images![0],
                            receiverId: widget.homeModel.userId!,
                            homeModel: widget.homeModel,
                            receiverName: widget.homeModel.name!,
                          ),
                        ));
                      } else if (hasChat == 1) {
                        context.getSnackBar(
                            snackText: 'يجب عليك أنهاء الدردشة الحالية أولا',
                            isError: true);
                      } else {
                        context.getSnackBar(
                            snackText:
                                'لأتاحة امكانية الدردشة, عليك الاشتراك بالرزمة الذهبية',
                            snackHelperText:
                                'بأمكانك الدخول الي حسابك عبر الضغط على زر "حسابي" أسفل الشاشة و شراء الرزمة الذهبية',
                            isError: true);
                      }
                      //  MagicRouter.navigateTo(ChatScreen(
                      //    receiverId: widget.homeModel.userId!,
                      //    receiverProdileImage: widget.homeModel.images![0],
                      //    homeModel: widget.homeModel,
                      //  ));
                    },
                    child: Card(
                      color: Colors.white.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: ColorManager.primaryColor, width: 1),
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.5)),
                          child: SvgPicture.asset(
                            ImageManager.chatIcon,
                            color: ColorManager.primaryColor,
                            width: 14,
                            height: 14,
                            fit: BoxFit.scaleDown,
                          )),
                    ),
                  ),
                  Card(
                    color: Colors.white.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    child: GestureDetector(
                      onTap: () {
                        // if (widget.homeModel.isLiked == false) {
                        //   BlocProvider.of<LikedPostBloc>(context).add(
                        //     LikePostEvent(
                        //         userId: widget.homeModel.id.toString()),
                        //   );
                        //   setState(() {
                        //     widget.homeModel.isLiked = true;
                        //   });
                        // } else {
                        //
                        //   setState(() {
                        //     widget.homeModel.isLiked = false;
                        //   });
                        // }

                        BlocProvider.of<LikedPostBloc>(context).add(
                          DisLikePostEvent(
                              userId: widget.homeModel.id.toString()),
                        );
                        final likedPartnersBloc =
                            BlocProvider.of<LikedPartnersBloc>(context);
                        likedPartnersBloc
                            .add(LoadLikedPartnersEvent(1, isReset: true));
                        BlocProvider.of<HomeBloc>(context).getHomeData();
                      },
                      child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: ColorManager.primaryColor, width: 1),
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.5)),
                          child: widget.homeModel.isLiked == true
                              ? const Icon(
                                  Icons.favorite,
                                  color: ColorManager.primaryColor,
                                )
                              : SvgPicture.asset(
                                  ImageManager.favIcon,
                                  width: 14,
                                  height: 14,
                                  fit: BoxFit.scaleDown,
                                )),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomText(
                    lines: 6,
                    align: TextAlign.start,
                    text: '${widget.homeModel.name}, ${widget.homeModel.age}',
                    fontSize: Dimensions.largeFont,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    align: TextAlign.left,
                    text: widget.homeModel.city,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: CustomText(
              text: widget.homeModel.about ?? '',
              fontSize: Dimensions.normalFont,
              align: TextAlign.start,
              lines: 2,
            )),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
