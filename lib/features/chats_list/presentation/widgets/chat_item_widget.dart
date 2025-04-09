import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/features/chat/data/data_source/chat_messages_dataSource.dart';
import 'package:zawaj/features/chat/data/repos/chat_message_repository.dart';
import 'package:zawaj/features/chat/domain/get_chat_messages_usecase.dart';
import 'package:zawaj/features/chat/presentation/chat_message_cubit/chat_messages_cubit.dart';
import 'package:zawaj/features/chat/presentation/screens/chat_screen.dart';
import 'package:zawaj/features/chats_list/data/model/chats_model.dart';
import 'package:zawaj/features/chats_list/presentation/cubit/get_chats_cubit.dart';
import 'package:zawaj/features/home/data/models/home_model.dart';
import 'package:zawaj/features/profile/presentation/bloc/profile_bloc.dart';

class ChatItemWidget extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String imageUrl;
  final String userId;
  final String lastMessageTime;
  final int unseenMessages;
  final bool lastMessageState;
  final HomeModel homeModel;
  final Chat chat;

  ChatItemWidget({
    required this.name,
    required this.lastMessage,
    required this.imageUrl,
    required this.userId,
    required this.homeModel,
    required this.lastMessageTime,
    required this.unseenMessages,
    required this.lastMessageState,
    required this.chat,
  });
  @override
  Widget build(BuildContext context) {
    final profileCubit = ProfileBloc.get(context).profileData;
    final chatsListCubit = BlocProvider.of<ChatsCubit>(context);
    void showPinChatDialog(BuildContext context, Chat chat) {
      String action = chat.isPinned == 0 ? 'تثبيت' : 'ألغاء تثبيت';

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: SvgPicture.asset(ImageManager.heartLogo)),
            content: CustomText(
              text: 'هل تريد $action هذه الدردشة؟',
              fontWeight: FontWeight.bold,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const CustomText(
                  text: 'ألغاء',
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  if (chat.isPinned == 0) {
                    chatsListCubit.pinChat(chat.chatId);
                  } else {
                    chatsListCubit.unpinChat(chat.chatId);
                  }
                  Navigator.of(context).pop();
                },
                child: CustomText(
                  text: action,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
      );
    }

    return GestureDetector(
      onLongPress: () {
        chat.isChatOpen == 1 ? null : showPinChatDialog(context, chat);
      },
      onTap: () {
        profileCubit?.hasChat == 1 && profileCubit?.chatUserId != userId
            ? context.getSnackBar(
                snackText: 'يجب عليك أنهاء الدردشة الحالية أولا', isError: true)
            : MagicRouter.navigateTo(BlocProvider(
                create: (context) => ChatMessagesCubit(
                    GetChatMessagesDataUseCase(
                        ChatMessagesRepositoryImpl(ChatDataProvider())))
                  ..getChatMessagesData(userId.toString()),
                child: ChatScreen(
                  receiverId: userId,
                  receiverProdileImage: imageUrl,
                  homeModel: homeModel,
                  receiverName: name,
                ),
              ));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                height: 90,
                width: 90,
                fit: BoxFit.fill,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Image.asset(
                  ImageManager.profileError,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (unseenMessages == 1)
                          const Icon(
                            Icons.fiber_manual_record_sharp,
                            color: ColorManager.primaryColor,
                            size: 12,
                          ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: CustomText(
                            text: name,
                            textOverFlow: TextOverflow.ellipsis,
                            align: TextAlign.start,
                            lines: 1,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomText(
                    textOverFlow: TextOverflow.ellipsis,
                    text: isGiphyLink(lastMessage) && lastMessageState == true
                        ? 'صورة متحركة'
                        : isVideoLink(lastMessage) && lastMessageState == true
                            ? 'ملف فيديو'
                            : lastMessageState == false
                                ? 'رسالة محذوفة'
                                : lastMessage,
                    align: TextAlign.start,
                    lines: 1,
                    fontWeight: unseenMessages == 1
                        ? FontWeight.normal
                        : FontWeight.normal,
                  ),
                ],
              ),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Column(
                children: [
                  CustomText(
                    text: lastMessageTime,
                    fontSize: 12,
                    color: Colors.grey.shade400,
                    textOverFlow: TextOverflow.ellipsis,
                    align: TextAlign.start,
                    lines: 1,
                    fontWeight: unseenMessages == 1
                        ? FontWeight.normal
                        : FontWeight.normal,
                  ),
                  chat.isPinned == 1 || chat.isChatOpen == 1
                      ? const Icon(Icons.push_pin_outlined,
                          color: ColorManager.primaryColor)
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isVideoLink(String messageContent) {
    return messageContent.contains(EndPoints.BASE_URL_image);
  }

  bool isGiphyLink(String messageContent) {
    return messageContent.contains("https://giphy.com/embed/");
  }
}
