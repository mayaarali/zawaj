/*
import 'dart:io';



import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PreviewPage extends StatefulWidget {
  final String? imagePath;
  final String? videoPath;
  const PreviewPage({super.key, this.imagePath, this.videoPath});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  VideoPlayerController? controller;
  Future<void> _startVideoPlayer() async {
    if (widget.videoPath != null) {
      controller = VideoPlayerController.file(File(widget.videoPath!));
      await controller!.initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
      });
      await controller!.setLooping(true);
      await controller!.play();
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.videoPath != null) {
      _startVideoPlayer();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widget.imagePath != null
            ? Image.file(
                File(widget.imagePath ?? ""),
                fit: BoxFit.cover,
              )
            : AspectRatio(
                aspectRatio: controller!.value.aspectRatio,
                child: VideoPlayer(controller!),
              ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popover/popover.dart';
import 'package:zawaj/core/camera/bloc/camera_bloc.dart';
import 'package:zawaj/core/camera/utlis/camera_utils.dart';
import 'package:zawaj/core/camera/utlis/permission_utils.dart';
import 'package:zawaj/core/camera/view/pages/camera_page.dart';
import 'package:zawaj/core/router/routes.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';
import 'package:zawaj/features/profile/presentation/pages/profile_page.dart';

class CameraPreview extends StatefulWidget {
  const CameraPreview({super.key});

  @override
  State<CameraPreview> createState() => _CameraPreviewState();
}

class _CameraPreviewState extends State<CameraPreview> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isFullScreen: true,
      child: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                //          MagicRouter.navigateTo(CameraPage());
                /*
                //   
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) {
                        return CameraBloc(
                          cameraUtils: CameraUtils(),
                          permissionUtils: PermissionUtils(),
                        )..add(const CameraInitialize(recordingLimit: 15));
                      },
                      child: const CameraPage(),
                    ),
                  ),
                );
                */
              },
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "Camera 📷",
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
