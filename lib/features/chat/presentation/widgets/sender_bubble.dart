import 'dart:ui';

import 'package:chat_bubbles/bubbles/bubble_special_two.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/features/chat/presentation/widgets/giphy_widget.dart';
import 'package:zawaj/features/chat/presentation/widgets/video_message_widget.dart';

class SenderBubble extends StatelessWidget {
  final String message;
  final bool isGiphy;
  final bool isVideo;
  final bool isActive;

  final DateTime messageTime;

  const SenderBubble(
      {super.key,
      required this.message,
      required this.isGiphy,
      required this.isVideo,
      required this.messageTime,
      required this.isActive});

  @override
  Widget build(BuildContext context) {
    String formattedTime =
        DateFormat('hh:mm a', window.locale.languageCode).format(messageTime);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isGiphy && isActive == true
            ? Align(
                alignment: Alignment.bottomRight,
                child: GiphyWidget(giphyUrl: message))
            : isVideo && isActive == true
                ? Align(
                    alignment: Alignment.bottomRight,
                    child: VideoMessageWidget(
                      videoUrl: message,
                    ),
                  )
                : BubbleSpecialTwo(
                    text: isActive == false ? 'لقد تم حذف الرسالة' : message,
                    color: ColorManager.primaryTextColor,
                    textStyle: const TextStyle(
                      fontSize: Dimensions.normalFont,
                      color: ColorManager.whiteTextColor,
                    )),
        Padding(
          padding: EdgeInsets.only(
              right: isGiphy ? context.width * 0.01 : context.width * 0.025),
          child: Text(
            formattedTime,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        )
      ],
    );
  }
}
