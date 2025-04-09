import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:popover/popover.dart';
import 'package:zawaj/core/constants/image_manager.dart';

class MessageSenderBar extends StatelessWidget {
  final sendMessageFunction;
  //final TextEditingController textController;

  const MessageSenderBar({
    super.key,
    required this.sendMessageFunction,
    // required this.textController
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Material(
          elevation: 30,
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          child: MessageBar(
            onSend: (value) {
              sendMessageFunction(value);
            },
            actions: [
              InkWell(
                child: SvgPicture.asset(ImageManager.videoLogo),
                onTap: () {
                  showPopover(
                    context: context,
                    barrierDismissible: false,
                    bodyBuilder: (context) => const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(padding: EdgeInsets.all(10), child: SizedBox()
                              // CameraPage(),
                              ),
                        ],
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    // width: MediaQuery.of(context).size.width,
                    //    height: MediaQuery.of(context).size.height,
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: InkWell(
                  child: SvgPicture.asset(ImageManager.gifLogo),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
