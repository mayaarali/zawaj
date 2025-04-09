import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:action_slider/action_slider.dart';
import 'package:animated_floating_widget/animated_floating_widget.dart';
import 'package:animated_menu/animated_menu.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:video_player/video_player.dart';

import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/constants/strings.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/extensions/snack_bar.dart';
import 'package:zawaj/core/helper/cache_helper.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/custom_appbar.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/core/widgets/loading_circle.dart';
import 'package:zawaj/features/chat/presentation/chat_message_cubit/chat_messages_cubit.dart';
import 'package:zawaj/features/chat/presentation/chat_message_cubit/chat_messages_states.dart';
import 'package:zawaj/features/chat/presentation/widgets/message_send_bar_widget.dart';
import 'package:zawaj/features/chat/presentation/widgets/profile_image_widget.dart';
import 'package:zawaj/features/chat/presentation/widgets/reason_alert_dialog.dart';
import 'package:zawaj/features/chat/presentation/widgets/reciever_bubble.dart';
import 'package:zawaj/features/chat/presentation/widgets/sender_bubble.dart';
import 'package:zawaj/features/chat/presentation/widgets/sequential_dialogs_widget.dart';
import 'package:zawaj/features/chat/presentation/widgets/video_action_slider_widget.dart';
import 'package:zawaj/features/dashboard/view.dart';
import 'package:zawaj/features/home/data/models/home_model.dart';
import 'package:zawaj/features/home/presentation/pages/partner_details_screen.dart';
import 'package:zawaj/features/profile/presentation/bloc/profile_bloc.dart';

import '../../data/data_source/chat_messages_dataSource.dart';
import '../../data/model/chat_messages_model.dart';
import '../../data/repos/chat_message_repository.dart';
import '../../domain/get_chat_messages_usecase.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverProdileImage;
  final String receiverName;
  final HomeModel homeModel;

  const ChatScreen({
    super.key,
    required this.receiverId,
    required this.receiverProdileImage,
    required this.homeModel,
    required this.receiverName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _sendMessgeController = TextEditingController();
  final List<String> _messages = [];
  final ScrollController _scrollController = ScrollController();
  late HubConnection _hubConnection;
  String _connectionId = '';
  GiphyGif? _selectedGif;
  bool _isSending = false;
  bool showArrowIcon = false;
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool _isRecording = false;
  bool _isSwitchingCamera = false;

  XFile? _videoFile;
  late Timer _recordingTimer;
  bool isNewMessageReceived = false;
  int _selectedCameraIndex = 0;
  final actionSliderController = ActionSliderController();

  late GetChatMessagesDataUseCase _getChatMessagesDataUseCase;
  int currentPage = 1;
  bool canFetchMoreMessages = true;
  late ChatData chatData;
  bool isLoadingMore = false;
  @override
  void initState() {
    super.initState();
    final chatMessagesRepository =
        ChatMessagesRepositoryImpl(ChatDataProvider());
    _getChatMessagesDataUseCase =
        GetChatMessagesDataUseCase(chatMessagesRepository);

    loadInitialChatData();
    log('widget.receiverId ${widget.receiverId}');
    _initSignalR();
    context.read<ChatMessagesCubit>().getChatMessagesData(widget.receiverId);
    ProfileBloc.get(context).getMyProfile();
    CacheHelper.setData(
        key: Strings.receiverUserIdChat, value: widget.receiverId);
  }

  @override
  void dispose() {
    _hubConnection.stop();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> loadInitialChatData() async {
    try {
      final initialChatData = await _getChatMessagesDataUseCase
          .call(widget.receiverId, page: currentPage);
      setState(() {
        chatData = initialChatData;
      });
    } catch (e) {}
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.high);
    await _cameraController.initialize();
  }

  Future<void> fetchMoreMessages(String user2Id) async {
    if (canFetchMoreMessages) {
      canFetchMoreMessages = false;
      setState(() {
        isLoadingMore = true;
      });
      try {
        final newMessages =
            await _getChatMessagesDataUseCase.call(user2Id, page: currentPage);

        setState(() {
          chatData.messages.addAll(newMessages.messages);
          currentPage++;
        });
      } catch (e) {
      } finally {
        setState(() {
          canFetchMoreMessages = true;
          isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _startRecording() async {
    try {
      await _initializeCamera();

      await _cameraController.startVideoRecording();
      setState(() {
        _isRecording = true;
      });

      _recordingTimer = Timer(const Duration(seconds: 41), _stopRecording);
    } catch (e) {
      log('Error starting video recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      setState(() {
        _isSending = true;
      });
      XFile videoFile = await _cameraController.stopVideoRecording();
      setState(() {
        _isRecording = false;
        _videoFile = videoFile;
      });
    } catch (e) {
      log('Error stopping video recording: $e');
    } finally {
      _recordingTimer.cancel();
      _cameraController.dispose();
      setState(() {
        _isSending = false;
      });
    }
  }

  Future<void> _switchCamera() async {
    try {
      setState(() {
        _isSwitchingCamera = true;
      });

      if (_isRecording) {
        XFile videoFile = await _cameraController.stopVideoRecording();
        setState(() {
          _isRecording = false;
          _videoFile = videoFile;
        });
      }

      await _cameraController.dispose();

      _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;

      _cameraController = CameraController(
        _cameras[_selectedCameraIndex],
        ResolutionPreset.high,
      );

      await _cameraController.initialize();

      setState(() {});

      await _cameraController.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      log('Error switching camera during recording: $e');
    } finally {
      setState(() {
        _isSwitchingCamera = false;
      });
    }
  }

  Future<void> _sendVideo(XFile videoFile) async {
    try {
      String url = '${EndPoints.BASE_URL}${EndPoints.convertFile}';
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(videoFile.path),
      });
      setState(() {
        _isSending = true;
      });
      Response response = await Dio().post(url, data: formData);
      if (response.statusCode == 200) {
        String path = response.data['path'];
        _sendMessage('${EndPoints.BASE_URL_image}$path');
        setState(() {
          _isSending = false;
        });
        _discardVideo();
      } else {
        log('Error sending video: ${response.statusCode}');
      }
    } catch (e) {
      log('Error sending video: $e');
    }
  }

  void _discardVideo() {
    setState(() {
      _videoFile = null;
    });
  }

  void _initSignalR() async {
    _hubConnection = HubConnectionBuilder().withUrl(
        "${EndPoints.signalRHub}${ProfileBloc.get(context).profileData!.id}",
        HttpConnectionOptions(
      logging: (level, message) async {
        fetchMoreMessages(widget.receiverId);
        final chatData = await _getChatMessagesDataUseCase(widget.receiverId,
            page: 1, pageSize: 10);

        setState(() {
          this.chatData = chatData;
        });

        ProfileBloc.get(context).getMyProfile();
      },
    )).build();

    _hubConnection.on("ReceiveMessage", (List<dynamic>? args) {
      log('===========> mmmmmmmmmmmmmmmmmmm${args!.last}');

      if (args != null && args.isNotEmpty) {
        setState(() {
          _messages.add(args.last.toString());
        });
      }
    });

    try {
      await _hubConnection.start();
      _connectionId = _hubConnection.connectionId!;
    } catch (e) {
      log("Error starting connection: $e");
    }
  }

  void _sendMessage(String messagee) {
    String? message = _sendMessgeController.text.trim();
    GiphyGif? gifFile = _selectedGif;
    if (message != null || gifFile != null) {
      _hubConnection.invoke(
        args: [
          ProfileBloc.get(context).profileData!.id,
          widget.receiverId,
          messagee
        ],
        "SendMessage",
      );
      if (message != null) {
        log('this is message $message');
      } else {
        log('A file is being sent');
      }
      _initSignalR();
      //fetchMoreMessages(widget.receiverId);
      // loadInitialChatData();

      // context
      //     .read<ChatMessagesCubit>()
      //     .getChatMessagesData(widget.receiverId, page: currentPage);
      _sendMessgeController.clear();
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<ChatMessagesCubit, ChatMessagesState>(
            builder: (context, state) {
              if (state is ChatMessagesLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ChatMessagesErrorState) {
                log('Error: ${state.error}');
                return Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: CustomAppBar(
                            isHeartTitle: true,
                            isBack: true,
                            isSettingIcon: true,
                            leading: GestureDetector(
                              onTap: () {
                                MagicRouter.navigateTo(PartnerDetailsScreen(
                                  homeModel: widget.homeModel,
                                ));
                              },
                              child: ProfileImageWidget(
                                imageUrl: widget.receiverProdileImage,
                                homeModel: widget.homeModel,
                              ),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [],
                            ),
                          ),
                        ),
                      ],
                    ),
                    _isSending
                        ? const Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: LinearProgressIndicator(),
                            ),
                          )
                        : _isRecording
                            ? const SizedBox()
                            : Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: MessageSendBarWidget(
                                  textController: _sendMessgeController,
                                  startRecording: _startRecording,
                                  sendMessage: (message) {
                                    if (message.isEmpty) {
                                    } else {
                                      _sendMessage(message);
                                    }
                                  },
                                )),
                    SequentialInstructionsDialogs()
                  ],
                );
              } else if (state is ChatMessagesLoadedState) {
                final chatMessgaeCubit =
                    BlocProvider.of<ChatMessagesCubit>(context);

                final isSubscribed =
                    ProfileBloc.get(context).profileData?.isSubscribed;
                final chatId = state.chatData.messages.first.chatId;
                return Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: CustomAppBar(
                            isHeartTitle: true,
                            isBack: true,
                            isSettingIcon: true,
                            leading: state
                                        .chatData.messages.first.isChatEnded ==
                                    1
                                ? const SizedBox()
                                : IconButton(
                                    onPressed: () {
                                      showAnimatedMenu(
                                        context: context,
                                        preferredAnchorPoint: const Offset(
                                          500,
                                          80,
                                        ),
                                        isDismissable: true,
                                        useRootNavigator: true,
                                        menu: AnimatedMenu(
                                          borderRadius: 10,
                                          items: [
                                            FadeIn(
                                              child: Container(
                                                height: 130,
                                                width: 200,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        state.chatData
                                                                    .isUserDeleted ==
                                                                true
                                                            ? null
                                                            : MagicRouter
                                                                .navigateTo(
                                                                    PartnerDetailsScreen(
                                                                homeModel: widget
                                                                    .homeModel,
                                                              ));
                                                      },
                                                      child: Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 2,
                                                          ),
                                                          ProfileImageWidget(
                                                            imageUrl: widget
                                                                .receiverProdileImage,
                                                            homeModel: widget
                                                                .homeModel,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Expanded(
                                                            child: CustomText(
                                                              align: TextAlign
                                                                  .start,
                                                              text: state.chatData
                                                                          .isUserDeleted ==
                                                                      true
                                                                  ? 'مستخدم محذوف'
                                                                  : widget
                                                                      .receiverName,
                                                              color: ColorManager
                                                                  .primaryColor,
                                                              textOverFlow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    const Divider(),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return ReasonAlertDialog(
                                                              title:
                                                                  'طلب إنهاء المحادثة',
                                                              onSubmit: (String
                                                                  reason) {
                                                                chatMessgaeCubit
                                                                    .endChat(
                                                                  chatId:
                                                                      chatId,
                                                                  reason:
                                                                      reason,
                                                                );
                                                                Navigator.pop(
                                                                    context,
                                                                    true);
                                                                ProfileBloc.get(
                                                                        context)
                                                                    .getMyProfile();
                                                              },
                                                            );
                                                          },
                                                        ).then((value) {
                                                          if (value == true) {
                                                            WidgetsBinding
                                                                .instance
                                                                .addPostFrameCallback(
                                                                    (_) {
                                                              context
                                                                  .getSnackBar(
                                                                snackText:
                                                                    'لقد تم إنهاء المحادثة بنجاح',
                                                                isError: false,
                                                              );

                                                              Future.delayed(
                                                                  const Duration(
                                                                      seconds:
                                                                          1),
                                                                  () {
                                                                MagicRouter
                                                                    .navigateAndPopAll(
                                                                  const DashBoardScreen(
                                                                      initialIndex:
                                                                          1),
                                                                );
                                                              });
                                                            });
                                                          }
                                                        });
                                                      },
                                                      child: const SizedBox(
                                                        child: Row(
                                                          children: [
                                                            ClipOval(
                                                                child: Icon(
                                                              Icons.block,
                                                              size: 43,
                                                              color: ColorManager
                                                                  .primaryColor,
                                                            )),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Expanded(
                                                              child: CustomText(
                                                                align: TextAlign
                                                                    .start,
                                                                text:
                                                                    'انهاء المحادثة',
                                                                color: ColorManager
                                                                    .primaryColor,
                                                                textOverFlow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.menu),
                                  ))),
                    state.chatData.messages.first.daysToEnd >= 1 &&
                            state.chatData.messages.first.daysToEnd <= 3
                        ? FloatingWidget(
                            verticalSpace: 10,
                            duration: const Duration(
                              seconds: 3,
                            ),
                            reverseDuration: const Duration(seconds: 1),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              width: context.width,
                              height: context.height * 0.05,
                              decoration: BoxDecoration(
                                  color: ColorManager.primaryColor,
                                  borderRadius: BorderRadius.circular(35)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text:
                                        'تنبيه : مدة الدردشة سوف تنتهي في خلال ${state.chatData.messages.first.daysToEnd} أيام',
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ReasonAlertDialog(
                                            title: 'طلب تمديد وقت المحادثة',
                                            onSubmit: (String reason) async {
                                              log(reason);
                                              String? message =
                                                  await chatMessgaeCubit
                                                      .extensionChatRequest(
                                                chatId: chatId,
                                                reason: reason,
                                              );
                                              Navigator.of(context).pop();
                                              context.getSnackBar(
                                                  snackText: message!,
                                                  isError: message ==
                                                          'ارسلت بالفعل طلب لمد هذه المحادثة'
                                                      ? true
                                                      : false);
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: const CustomText(
                                      text: 'مدد المدة الأن',
                                      color: Colors.white,
                                      textDecoration: TextDecoration.underline,
                                      decorationColor: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox(),
                    if (showArrowIcon)
                      GestureDetector(
                        onTap: () {
                          if (_scrollController.hasClients) {
                            _scrollController.animateTo(
                              _scrollController.position.minScrollExtent,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: const Icon(Icons.arrow_downward,
                            color: ColorManager.primaryColor),
                      ),
                    if (isLoadingMore)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: LinearProgressIndicator(),
                      ),
                    NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        // Check if the user has scrolled to the top of the list
                        if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.minScrollExtent) {
                          setState(() {
                            showArrowIcon = false;
                            // currentPage = 1;
                          });
                        } else if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                          fetchMoreMessages(widget.receiverId);
                        } else {
                          setState(() {
                            showArrowIcon = true;
                          });
                        }
                        return true;
                      },
                      child: Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          reverse: true,
                          child: ListView.builder(
                            reverse: true,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: chatData.messages.length,
                            itemBuilder: (context, index) {
                              final currentMessage = chatData.messages[index];
                              final previousMessage = index > 0
                                  ? chatData.messages[index - 1]
                                  : null;
                              final bool isFirstMessageOfDay =
                                  previousMessage == null ||
                                      !chatMessgaeCubit.isSameDay(
                                          currentMessage.sentAt,
                                          previousMessage.sentAt);

                              return Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (isFirstMessageOfDay)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 8.0),
                                          child: Text(
                                            DateFormat(
                                                    'dd/MM/yyyy '
                                                    'الساعة'
                                                    ' hh:mm a',
                                                    window.locale.languageCode)
                                                .format(currentMessage.sentAt),
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                        ),
                                      if (widget.receiverId !=
                                          currentMessage.recipientId)
                                        AbsorbPointer(
                                          absorbing:
                                              currentMessage.isChatEnded == 1
                                                  ? true
                                                  : false,
                                          child: RecieverBubble(
                                            message: currentMessage.content,
                                            imagePath:
                                                widget.receiverProdileImage,
                                            isGiphy:
                                                chatMessgaeCubit.isGiphyLink(
                                                    currentMessage.content),
                                            isVideo:
                                                chatMessgaeCubit.isVideoLink(
                                                    currentMessage.content),
                                            homeModel: widget.homeModel,
                                            messageTime: currentMessage.sentAt,
                                            isActive: currentMessage.isActive,
                                            isUserDeleted:
                                                state.chatData.isUserDeleted,
                                          ),
                                        )
                                      else
                                        GestureDetector(
                                          onLongPress: () {
                                            final currentTime =
                                                DateTime.now().toLocal();
                                            final messageTime =
                                                currentMessage.sentAt.toLocal();
                                            final timeDifference = currentTime
                                                .difference(messageTime);
                                            log('==============> timeDifference inMinutes ${timeDifference.inMinutes}');
                                            if (timeDifference.inMinutes < 10 &&
                                                currentMessage.isActive ==
                                                    true) {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        ListTile(
                                                          title: const Text(
                                                              'مسح الرسالة'),
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context,
                                                                'delete');
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ).then((value) {
                                                if (value == 'delete') {
                                                  context
                                                      .read<ChatMessagesCubit>()
                                                      .deleteMessage(
                                                          currentMessage
                                                              .messageId);
                                                }
                                              });
                                            }
                                          },
                                          child: AbsorbPointer(
                                            absorbing:
                                                currentMessage.isChatEnded == 1
                                                    ? true
                                                    : false,
                                            child: SenderBubble(
                                              isActive: currentMessage.isActive,
                                              message: currentMessage.content,
                                              isGiphy:
                                                  chatMessgaeCubit.isGiphyLink(
                                                      currentMessage.content),
                                              isVideo:
                                                  chatMessgaeCubit.isVideoLink(
                                                      currentMessage.content),
                                              messageTime:
                                                  currentMessage.sentAt,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    _isSending
                        ? const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: LinearProgressIndicator(),
                          )
                        : _isRecording
                            ? const SizedBox()
                            : (isSubscribed == false)
                                ? const Padding(
                                    padding: EdgeInsets.only(bottom: 8.0),
                                    child: CustomText(
                                      text:
                                          'يرجى الاشتراك في الرزمة الذهبية للرد على الرسائل',
                                      align: TextAlign.center,
                                    ),
                                  )
                                : chatData.isUserDeleted == true
                                    ? const Padding(
                                        padding: EdgeInsets.only(bottom: 8.0),
                                        child: Center(
                                          child: CustomText(
                                            text:
                                                'لقد تم حذف الحساب لا يمكنك ارسال أو استقبال رسائل',
                                            align: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    : chatData.messages.first.isChatEnded == 1
                                        ? const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 8.0),
                                            child: Center(
                                              child: CustomText(
                                                text:
                                                    'لقد أنتهت المحادثة لايمكنك ارسال أو استقبال رسائل',
                                                align: TextAlign.center,
                                              ),
                                            ))
                                        : MessageSendBarWidget(
                                            textController:
                                                _sendMessgeController,
                                            startRecording: _startRecording,
                                            sendMessage: (message) {
                                              if (message.isEmpty) {
                                              } else {
                                                _sendMessage(message);
                                              }
                                            },
                                          )
                  ],
                );
              } else if (state is MessageDeleted) {
                return const LoadingCircle();
              } else {
                return const Center(child: Text('! حدث خطأ '));
              }
            },
          ),
          _isRecording
              ? Positioned.fill(
                  child: Container(
                    height: context.height,
                    width: context.width,
                    color: ColorManager.primaryColor.withOpacity(0.5),
                    child: Center(
                      child: ClipOval(
                        child: SizedBox(
                          height: 380,
                          width: 350,
                          child: CameraPreview(_cameraController),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          _isRecording
              ? Positioned(
                  bottom: 100.0,
                  left: 110.0,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Container(
                                height: 50,
                                width: 50,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorManager.primaryTextColor),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 40,
                                )),
                            onPressed:
                                _isRecording ? _stopRecording : _startRecording,
                          ),
                          IconButton(
                            icon: Container(
                                height: 50,
                                width: 50,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorManager.primaryTextColor),
                                child: const Icon(
                                  Icons.rotate_left,
                                  color: Colors.white,
                                  size: 40,
                                )),
                            onPressed:
                                _isSwitchingCamera ? null : _switchCamera,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : _videoFile != null &&
                      _isSwitchingCamera == false &&
                      _isSending == false
                  ? Positioned.fill(
                      child: Container(
                        height: context.height,
                        width: context.width,
                        color: ColorManager.primaryColor.withOpacity(0.5),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 300,
                                width: 200,
                                child: VideoPlayerWidget(file: _videoFile!),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                ColorManager.primaryTextColor),
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 40,
                                        )),
                                    onPressed: () async {
                                      if (_videoFile != null) {
                                        await _sendVideo(_videoFile!);
                                      } else {
                                        log("No video file available to send");
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 40,
                                        )),
                                    onPressed: _discardVideo,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
          _isRecording
              ? Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: VideoActionSliderWidget(
                    actionSliderController: actionSliderController,
                    stopVideoRecording: () async {
                      await _cameraController.stopVideoRecording();
                      _cameraController.stopVideoRecording();
                      _discardVideo();
                    },
                    onRecordingStopped: () {
                      setState(() {
                        _isRecording = false;
                      });
                    },
                  ))
              : const SizedBox(),
        ],
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final XFile file;

  const VideoPlayerWidget({Key? key, required this.file}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isEnded = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.file.path))
      ..initialize().then((_) {
        setState(() {});
      });

    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        setState(() {
          _isPlaying = false;
          _isEnded = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                VideoPlayer(_controller),
                VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  colors: const VideoProgressColors(
                      playedColor: ColorManager.primaryColor),
                ),
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 50.0,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPlaying ? _controller.pause() : _controller.play();
                      _isPlaying = !_isPlaying;
                    });
                  },
                ),
              ],
            ),
          )
        : const Center(child: LoadingCircle());
  }
}
