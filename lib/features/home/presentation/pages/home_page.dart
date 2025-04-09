import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/helper/profile_helper.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/build_dialog.dart';
import 'package:zawaj/core/widgets/custom_appbar.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/core/widgets/loading_circle.dart';
import 'package:zawaj/features/chat/data/data_source/chat_messages_dataSource.dart';
import 'package:zawaj/features/chat/data/repos/chat_message_repository.dart';
import 'package:zawaj/features/chat/domain/get_chat_messages_usecase.dart';
import 'package:zawaj/features/chat/presentation/chat_message_cubit/chat_messages_cubit.dart';
import 'package:zawaj/features/chat/presentation/screens/chat_screen.dart';
import 'package:zawaj/features/favorites/presentation/bloc/favorites_post_bloc.dart';
import 'package:zawaj/features/home/data/models/home_model.dart';
import 'package:zawaj/features/home/presentation/pages/partner_details_screen.dart';
import 'package:zawaj/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/features/setup_account/presentation/pages/rejectionPage.dart';

import '../../../payment/presentation/pages/payment_possibilities.dart';
import '../blocs/home_bloc/home_bloc.dart';
import '../blocs/likedPost_bloc/liked_post_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 1;
  bool isLoading = false;
  bool isInitialLoad = true;
  String today = DateFormat('MM/dd/yyyy').format(DateTime.now());
  @override
  void initState() {
    super.initState();
    ProfileBloc.get(context).getMyProfile();

    // CacheHelper.setData(key: Strings.isSubscribed, value: true);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ProfileHelper.checkVerificationAndSubscription(context);
    // });

    BlocProvider.of<LikedPartnersBloc>(context)
        .add(LoadLikedPartnersEvent(1, isReset: true));
    if (isInitialLoad) {
      loadHomeData(reset: true);
      isInitialLoad = false;
    }

    // ProfileBloc.get(context).getMyProfile();
    // final verificationState =
    //     ProfileBloc.get(context).profileData?.verificationStatus.toString();

    // if (verificationState == 'Rejected') {
    //   log('yoooooouuuuuuuu arrrreeee rejecteddd');
    //   MagicRouter.navigateAndPopAll(const YourProfileIsRejected());
    // }
    // final expiredDateSubscribe =
    //     ProfileBloc.get(context).profileData?.expiredDateSubscribe.toString() ??
    //         '';

    // if (expiredDateSubscribe == today) {
    //   CacheHelper.setData(key: Strings.isSubscribed, value: false);
    //   MagicRouter.navigateAndPopAll(const PayementPossibility(
    //     isFromProfileScreen: false,
    //   ));

    //   log('isSubscribed => ${CacheHelper.getData(key: Strings.isSubscribed)}');
    // }
  }

  Future<void> loadHomeData({bool reset = false}) async {
    if (reset) {
      currentPage = 1;
      HomeBloc.get(context).homeModelList.clear();
    }

    if (!isLoading) {
      setState(() => isLoading = true);

      final response = await HomeBloc.get(context)
          .homeRepositoryImp
          .getPartnerData(page: currentPage);

      response.fold((failure) {
        if (mounted) {
          setState(() => isLoading = false);
        }
      }, (data) {
        if (mounted) {
          setState(() {
            isLoading = false;
            currentPage++;
            if (reset) {
              HomeBloc.get(context).homeModelList = data;
            } else {
              HomeBloc.get(context).homeModelList.addAll(data);
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  surfaceTintColor: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CupertinoActivityIndicator(
                          color: ColorManager.primaryColor,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'تحميل ...',
                          style:
                              TextStyle(color: ColorManager.primaryTextColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return BlocConsumer<LikedPostBloc, HomeState>(
            listener: (context, state) {
              if (state is IsLikedPostFailure) {
                context.getSnackBar(snackText: state.message, isError: true);
              }
              if (state is IsLikedPostSuccess) {
                //BlocProvider.of<HomeBloc>(context).getHomeData();

                context.getSnackBar(
                  snackText: state.message,
                );

                // loadHomeData();
              }

              if (state is RemoveUserFailure) {
                context.getSnackBar(snackText: state.message, isError: true);
              }

              if (state is RemoveUserSuccess) {
                //BlocProvider.of<HomeBloc>(context).getHomeData();

                context.getSnackBar(
                  snackText: state.message,
                );
              }
            },
            builder: (context, state) {
              return NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!isLoading &&
                      scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                    loadHomeData();
                  }
                  return true;
                },
                child: CustomScaffold(
                  isFullScreen: true,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CustomAppBar(
                        isSettingIcon: true,
                        isBack: false,
                        isHeartTitle: true,
                        leading: MenuButton(),
                        //  GestureDetector(
                        //   onTap: () {
                        //     showPopover(
                        //         context: context,
                        //         bodyBuilder: (context) =>
                        //             const OtherEditsPopUp(),
                        //         backgroundColor: Colors.transparent,
                        //         radius: 25,
                        //         width: 250);
                        //     //  MagicRouter.navigateTo(
                        //     //      SetPartnerData(isUpdated: true));
                        //   },
                        //   child: SvgPicture.asset(
                        //     ImageManager.menuIcon,
                        //     fit: BoxFit.scaleDown,
                        //   ),
                        // ),
                      ),
                      HomeBloc.get(context).homeModelList.isEmpty
                          ? const Expanded(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: Strings.noRequiredyet,
                                ),
                              ],
                            ))
                          : Expanded(
                              child: ListView.builder(
                                itemCount:
                                    HomeBloc.get(context).homeModelList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return PartnerWidget(
                                    homeModel: HomeBloc.get(context)
                                        .homeModelList[index],
                                    isSubscribed: ProfileBloc.get(context)
                                            .profileData
                                            ?.isSubscribed ??
                                        false,
                                    onRemoveUser: (removedUser) {
                                      setState(() {
                                        HomeBloc.get(context)
                                            .homeModelList
                                            .removeWhere((user) =>
                                                user.userId.toString() ==
                                                removedUser.userId);
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                      if (isLoading)
                        const LinearProgressIndicator(
                          color: ColorManager.primaryColor,
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

class PartnerWidget extends StatefulWidget {
  PartnerWidget(
      {Key? key,
      required this.homeModel,
      required this.isSubscribed,
      required this.onRemoveUser})
      : super(key: key);
  final HomeModel homeModel;
  final bool isSubscribed;
  final Function(HomeModel) onRemoveUser;

  @override
  _PartnerWidgetState createState() => _PartnerWidgetState();
}

String receiverUserIdChat = CacheHelper.getData(
  key: Strings.receiverUserIdChat,
);

class _PartnerWidgetState extends State<PartnerWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LikedPostBloc, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: widget.homeModel.images == null ||
                          widget.homeModel.images!.isEmpty
                      ? const Icon(Icons.add)
                      : GestureDetector(
                          onTap: () {
                            MagicRouter.navigateTo(PartnerDetailsScreen(
                                homeModel: widget.homeModel));
                          },
                          child: Image.network(
                              EndPoints.BASE_URL_image +
                                  widget.homeModel.images![0],
                              width: context.width,
                              height: context.height * 0.5,
                              fit: BoxFit.fill,
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
                          }, frameBuilder: (context, child, frame,
                                  wasSynchronouslyLoaded) {
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
                          }),
                        ),
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
                                  final likedPartnersBloc =
                                      BlocProvider.of<LikedPartnersBloc>(
                                          context);
                                  likedPartnersBloc.add(
                                      LoadLikedPartnersEvent(1, isReset: true));
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
                                      color: ColorManager.primaryColor,
                                      width: 1),
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
                      Card(
                        color: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        child: GestureDetector(
                          onTap: () {
                            final isSubscribed = ProfileBloc.get(context)
                                .profileData
                                ?.isSubscribed;
                            final chatUserId = ProfileBloc.get(context)
                                .profileData
                                ?.chatUserId;
                            final hasChat =
                                ProfileBloc.get(context).profileData?.hasChat;
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
                                  receiverProdileImage:
                                      EndPoints.BASE_URL_image +
                                          widget.homeModel.images![0],
                                  receiverId: widget.homeModel.userId!,
                                  homeModel: widget.homeModel,
                                  receiverName: widget.homeModel.name!,
                                ),
                              ));
                            } else if (hasChat == 1) {
                              context.getSnackBar(
                                  snackText:
                                      'يجب عليك أنهاء الدردشة الحالية أولا',
                                  isError: true);
                            } else {
                              context.getSnackBar(
                                  snackText:
                                      'لأتاحة امكانية الدردشة, عليك الاشتراك بالرزمة الذهبية',
                                  snackHelperText:
                                      'بأمكانك الدخول الي حسابك عبر الضغط على زر "حسابي" أسفل الشاشة و شراء الرزمة الذهبية',
                                  isError: true);
                            }
                          },
                          child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ColorManager.primaryColor,
                                      width: 1),
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
                            if (BlocProvider.of<LikedPostBloc>(context)
                                    .isLoading ==
                                false) {
                              if (widget.homeModel.isLiked == false) {
                                BlocProvider.of<LikedPostBloc>(context).add(
                                  LikePostEvent(
                                      userId: widget.homeModel.id.toString()),
                                );

                                setState(() {
                                  widget.homeModel.isLiked = true;
                                });
                              } else {
                                BlocProvider.of<LikedPostBloc>(context).add(
                                  DisLikePostEvent(
                                      userId: widget.homeModel.id.toString()),
                                );
                                setState(() {
                                  widget.homeModel.isLiked = false;
                                });
                                final likedPartnersBloc =
                                    BlocProvider.of<LikedPartnersBloc>(context);
                                likedPartnersBloc.add(
                                    LoadLikedPartnersEvent(1, isReset: true));
                                // BlocProvider.of<HomeBloc>(context)
                                //     .getHomeData();
                              }
                            } else {}
                          },
                          child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ColorManager.primaryColor,
                                      width: 1),
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
                    // CustomText(
                    //   text: widget.homeModel.age.toString(),
                    //   fontSize: Dimensions.largeFont,
                    //   align: TextAlign.start,
                    //   textOverFlow: TextOverflow.ellipsis,
                    // ),
                    // const SizedBox(
                    //   width: 10,
                    // ),
                    Expanded(
                      child: CustomText(
                        lines: 6,
                        align: TextAlign.start,
                        text:
                            '${widget.homeModel.name}, ${widget.homeModel.age}',
                        fontSize: Dimensions.largeFont,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    // const Spacer(
                    //   flex: 3,
                    // ),
                    Align(
                      alignment: Alignment.topLeft,
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
      },
    );
  }
}
