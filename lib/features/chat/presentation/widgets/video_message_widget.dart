import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
//import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:zawaj/core/constants/color_manager.dart';

class VideoMessageWidget extends StatefulWidget {
  const VideoMessageWidget({
    super.key,
    required this.videoUrl,
  });
  final String videoUrl;

  @override
  State<VideoMessageWidget> createState() => _VideoMessageWidgetState();
}

class _VideoMessageWidgetState extends State<VideoMessageWidget> {
  late VideoPlayerController videoPlayerController;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ClipOval(
            child: SizedBox(
                height: 200, width: 200, child: VideoPlayer(_controller)),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
            icon: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: ColorManager.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
