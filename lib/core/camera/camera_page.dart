/*
/////////////OLD CAMERA//////////////
import 'package:camera/camera.dart';



import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zawaj/core/camera/preview_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});
  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isCameraInitialized = true;
  //late final
  late List<CameraDescription> _cameras;
  bool _isRecording = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    initCamera();
    super.initState();
  }

  Future<void> initCamera() async {
    PermissionStatus status = await Permission.camera.request();

    if (status.isGranted) {
      // Camera permission granted, continue with camera initialization
      _cameras = await availableCameras();
      // Initialize the camera with the first camera in the list
      await onNewCameraSelected(_cameras.first);
    } else {
      // Camera permission denied, handle accordingly (show an error message, etc.)
      // You can use the `status.isPermanentlyDenied` flag to check if the permission is permanently denied
    }
    _cameras = await availableCameras();
    // Initialize the camera with the first camera in the list
    await onNewCameraSelected(_cameras.first);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> onNewCameraSelected(CameraDescription description) async {
    final previousCameraController = _controller;

    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      description,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Initialize controller
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      debugPrint('Error initializing camera: $e');
    }
    // Dispose the previous controller

    //DAAAAAAAA
    //await previousCameraController?.dispose();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        _controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Update the Boolean
    if (mounted) {
      setState(() {
        _isCameraInitialized = _controller!.value.isInitialized;
      });
    }
  }

  Future<XFile?> capturePhoto() async {
    final CameraController? cameraController = _controller;
    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      //await cameraController.setFlashMode(FlashMode.off); //optional
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  void _onTakePhotoPressed() async {
    final navigator = Navigator.of(context);
    final xFile = await capturePhoto();
    if (xFile != null) {
      if (xFile.path.isNotEmpty) {
        navigator.push(
          MaterialPageRoute(
            builder: (context) => PreviewPage(
              imagePath: xFile.path,
            ),
          ),
        );
      }
    }
  }

  Future<XFile?> captureVideo() async {
    final CameraController? cameraController = _controller;
    try {
      setState(() {
        _isRecording = true;
      });
      await cameraController?.startVideoRecording();
      await Future.delayed(const Duration(seconds: 5));
      final video = await cameraController?.stopVideoRecording();
      setState(() {
        _isRecording = false;
      });
      return video;
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  void _onRecordVideoPressed() async {
    final navigator = Navigator.of(context);
    final xFile = await captureVideo();
    if (xFile != null) {
      if (xFile.path.isNotEmpty) {
        navigator.push(
          MaterialPageRoute(
            builder: (context) => PreviewPage(
              videoPath: xFile.path,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCameraInitialized &&
        _controller != null &&
        _controller!.value.isInitialized) {
      return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: CameraPreview(_controller!)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isRecording ? null : _onRecordVideoPressed,
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(70, 70),
                      shape: const CircleBorder(),
                      backgroundColor: Colors.white),
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.videocam,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
*/
//cameraaaa