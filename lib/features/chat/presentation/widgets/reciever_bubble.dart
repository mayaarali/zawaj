import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_two.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/features/chat/presentation/widgets/giphy_widget.dart';
import 'package:zawaj/features/chat/presentation/widgets/video_message_widget.dart';
import 'package:zawaj/features/home/data/models/home_model.dart';
import 'package:zawaj/features/home/presentation/pages/partner_details_screen.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/widgets/build_dialog.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';

class RecieverBubble extends StatelessWidget {
  final String message;
  final String imagePath;
  final DateTime messageTime;
  final bool isGiphy;
  final bool isVideo;
  final bool isActive;
  final bool isUserDeleted;
  final HomeModel homeModel;

  const RecieverBubble(
      {super.key,
      required this.message,
      required this.imagePath,
      required this.isGiphy,
      required this.isVideo,
      required this.isActive,
      required this.homeModel,
      required this.isUserDeleted,
      required this.messageTime});

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('hh:mm a', ui.window.locale.languageCode)
        .format(messageTime);
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  isUserDeleted == true
                      ? null
                      : MagicRouter.navigateTo(PartnerDetailsScreen(
                          homeModel: homeModel,
                        ));
                },
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: imagePath,
                    height: 30,
                    width: 30,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => InkWell(
                      onTap: () {
                        isUserDeleted == true
                            ? null
                            : MagicRouter.navigateTo(PartnerDetailsScreen(
                                homeModel: homeModel,
                              ));
                      },
                      child: ClipOval(
                          child: Image.asset(
                        ImageManager.profileError,
                        height: 30,
                        width: 30,
                      )),
                    ),
                  ),
                ),
              ),
              isGiphy && isActive == true
                  ? Align(
                      alignment: Alignment.bottomLeft,
                      child: GiphyWidget(giphyUrl: message))
                  : isVideo && isActive == true
                      ? Align(
                          alignment: Alignment.bottomLeft,
                          child: VideoMessageWidget(
                            videoUrl: message,
                          ),
                        )
                      : BubbleSpecialTwo(
                          isSender: false,
                          text: isActive == false
                              ? 'لقد تم حذف الرسالة'
                              : message,
                          color: ColorManager.fadePinkColor,
                          textStyle: const TextStyle(
                            fontSize: Dimensions.normalFont,
                            color: ColorManager.primaryTextColor,
                          )),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: context.width * 0.12),
            child: Text(
              formattedTime,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          )
        ],
      ),
    );
  }
}
