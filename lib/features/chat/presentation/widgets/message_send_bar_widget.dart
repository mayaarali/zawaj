import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/end_points.dart';
import 'package:zawaj/core/constants/image_manager.dart';

class MessageSendBarWidget extends StatefulWidget {
  final TextEditingController textController;
  final VoidCallback startRecording;
  final Function(String) sendMessage;

  const MessageSendBarWidget({
    Key? key,
    required this.textController,
    required this.startRecording,
    required this.sendMessage,
  }) : super(key: key);

  @override
  _MessageSendBarWidgetState createState() => _MessageSendBarWidgetState();
}

class _MessageSendBarWidgetState extends State<MessageSendBarWidget> {
  GiphyGif? _selectedGif;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: widget.startRecording,
            child: SvgPicture.asset(ImageManager.videoLogo),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: InkWell(
              onTap: () async {
                GiphyGif? gif = await GiphyGet.getGif(
                  context: context,
                  apiKey: EndPoints.gifAPIKEY,
                  lang: GiphyLanguage.english,
                  randomID: "abcd",
                  tabColor: ColorManager.primaryColor,
                  debounceTimeInMilliseconds: 350,
                );
                setState(() {
                  _selectedGif = gif;
                });

                if (_selectedGif != null) {
                  widget.sendMessage(_selectedGif!.embedUrl.toString());
                }
              },
              child: SvgPicture.asset(ImageManager.gifLogo),
            ),
          ),
          Expanded(
            child: TextField(
              controller: widget.textController,
              decoration: const InputDecoration(
                hintText: 'اكتب رسالة ...',
                border: InputBorder.none,
              ),
            ),
          ),
          InkWell(
            onTap: () => widget.sendMessage(widget.textController.text.trim()),
            child: SvgPicture.asset(
              ImageManager.sendIcon,
              width: 40,
              height: 40,
            ),
          ),
        ],
      ),
    );
  }
}
