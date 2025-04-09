import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:zawaj/core/camera/bloc/camera_bloc.dart';
import 'package:zawaj/core/camera/bloc/camera_state.dart';
import 'package:zawaj/core/camera/enums/camera_enums.dart';
import 'package:zawaj/core/camera/utlis/screenshot_utils.dart';
import 'package:zawaj/core/camera/view/pages/video_player.dart';
import 'package:zawaj/core/camera/view/widgets/animated_bar.dart';
import 'package:zawaj/core/constants/color_manager.dart';

// class CameraPage extends StatefulWidget {
//   const CameraPage({super.key});

//   @override
//   State<CameraPage> createState() => _CameraPageState();
// }

// class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
//   late CameraBloc cameraBloc;
//   final GlobalKey screenshotKey = GlobalKey();
//   Uint8List? screenshotBytes;
//   bool isThisPageVisibe = true;

//   @override
//   void initState() {
//     cameraBloc = BlocProvider.of<CameraBloc>(context);
//     WidgetsBinding.instance.addObserver(this);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     cameraBloc.add(CameraReset());
//     cameraBloc.close();
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (cameraBloc.getController() == null) return;

//     if (state == AppLifecycleState.inactive) {
//       cameraBloc.add(CameraDisable());
//     }
//     if (state == AppLifecycleState.resumed) {
//       if (isThisPageVisibe) {
//         cameraBloc.add(CameraEnable());
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SizedBox(
//           height: 400,
//           width: 300,
//           child: VisibilityDetector(
//             key: const Key("my_camera"),
//             onVisibilityChanged: _handleVisibilityChanged,
//             child: BlocConsumer<CameraBloc, CameraState>(
//               listener: _cameraBlocListener,
//               builder: _cameraBlocBuilder,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void _cameraBlocListener(BuildContext context, CameraState state) {
//     if (state is CameraRecordingSuccess) {
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (_) => VideoPage(videoFile: state.file),
//         ),
//       );
//     } else if (state is CameraReady && state.hasRecordingError) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           backgroundColor: Colors.black45,
//           duration: Duration(milliseconds: 1000),
//           content: Text(
//             'Please record for at least 2 seconds.',
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       );
//     } else if (state is CameraInitial) {
//       cameraBloc.add(CameraEnable());
//     }
//   }

//   void _handleVisibilityChanged(VisibilityInfo info) {
//     if (info.visibleFraction == 0.0) {
//       if (mounted) {
//         cameraBloc.add(CameraDisable());
//         isThisPageVisibe = false;
//       }
//     } else {
//       isThisPageVisibe = true;
//       cameraBloc.add(CameraEnable());
//     }
//   }

//   void startRecording() async {
//     try {
//       takeCameraScreenshot(key: screenshotKey).then((value) {
//         screenshotBytes = value;
//       });
//     } catch (e) {
//       rethrow;
//     }
//     cameraBloc.add(CameraRecordingStart());
//   }

//   void stopRecording() async {
//     cameraBloc.add(CameraRecordingStop());
//   }

//   Widget _cameraBlocBuilder(BuildContext context, CameraState state) {
//     bool disableButtons = !(state is CameraReady && !state.isRecordingVideo);
//     return Column(
//       children: [
//         Expanded(
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               RepaintBoundary(
//                 key: screenshotKey,
//                 child: AnimatedSwitcher(
//                   duration: const Duration(milliseconds: 400),
//                   switchInCurve: Curves.linear,
//                   transitionBuilder:
//                       (Widget child, Animation<double> animation) {
//                     return FadeTransition(
//                       opacity: animation,
//                       alwaysIncludeSemantics: true,
//                       child: child,
//                     );
//                   },
//                   child: state is CameraReady
//                       ? Builder(builder: (context) {
//                           var controller = cameraBloc.getController();

//                           return Column(
//                             children: [
//                               Container(
//                                 height: 300,
//                                 width: 300,
//                                 child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(300),
//                                     child: CameraPreview(controller!)),
//                               ),
//                             ],
//                           );
//                           //  );
//                         })
//                       : state is CameraInitial && screenshotBytes != null
//                           ? Container(
//                               constraints: const BoxConstraints.expand(),
//                               decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                   image: MemoryImage(screenshotBytes!),
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               child: BackdropFilter(
//                                 filter: ImageFilter.blur(
//                                     sigmaX: 15.0, sigmaY: 15.0),
//                                 child: Container(),
//                               ),
//                             )
//                           : const SizedBox.shrink(),
//                 ),
//               ),
//               if (state is CameraError) errorWidget(state),
//               Positioned(
//                 bottom: 0,
//                 child: SizedBox(
//                   width: 250,
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       IgnorePointer(
//                         ignoring: state is! CameraReady ||
//                             state.decativateRecordButton,
//                         child: Opacity(
//                           opacity: state is! CameraReady ||
//                                   state.decativateRecordButton
//                               ? 0.4
//                               : 1,
//                           child: animatedProgressButton(state),
//                         ),
//                       ),
//                       Positioned(
//                         right: 0,
//                         child: Visibility(
//                           visible: !disableButtons,
//                           child: CircleAvatar(
//                             backgroundColor: ColorManager.secondaryPinkColor
//                                 .withOpacity(0.8),
//                             radius: 20,
//                             child: IconButton(
//                               onPressed: () async {
//                                 try {
//                                   screenshotBytes = await takeCameraScreenshot(
//                                       key: screenshotKey);
//                                   if (context.mounted)
//                                     cameraBloc.add(CameraSwitch());
//                                 } catch (e) {}
//                               },
//                               icon: const Icon(
//                                 Icons.cameraswitch,
//                                 color: ColorManager.primaryColor,
//                                 size: 20,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         left: 0,
//                         child: Visibility(
//                           visible: !disableButtons,
//                           child: StatefulBuilder(
//                               builder: (context, localSetState) {
//                             return GestureDetector(
//                               onTap: () {
//                                 final List<int> time = [15, 30, 60];
//                                 int currentIndex = time
//                                     .indexOf(cameraBloc.recordDurationLimit);
//                                 localSetState(() {
//                                   cameraBloc.setRecordDurationLimit =
//                                       time[(currentIndex + 1) % time.length];
//                                 });
//                               },
//                               child: CircleAvatar(
//                                 backgroundColor:
//                                     ColorManager.fadePinkColor.withOpacity(0.8),
//                                 radius: 20,
//                                 child: FittedBox(
//                                     child: Text(
//                                   "${cameraBloc.recordDurationLimit}",
//                                   style: const TextStyle(
//                                     color: ColorManager.primaryColor,
//                                   ),
//                                 )),
//                               ),
//                             );
//                           }),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget animatedProgressButton(CameraState state) {
//     bool isRecording = state is CameraReady && state.isRecordingVideo;
//     return GestureDetector(
//       onTap: () async {
//         if (isRecording) {
//           stopRecording();
//         } else {
//           startRecording();
//         }
//       },
//       onLongPress: () {
//         startRecording();
//       },
//       onLongPressEnd: (_) {
//         stopRecording();
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         height: isRecording ? 90 : 80,
//         width: isRecording ? 90 : 80,
//         child: Stack(
//           children: [
//             AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: ColorManager.secondaryPinkColor.withOpacity(0.8))),
//             ValueListenableBuilder(
//                 valueListenable: cameraBloc.recordingDuration,
//                 builder: (context, val, child) {
//                   return TweenAnimationBuilder<double>(
//                       duration: Duration(milliseconds: isRecording ? 1100 : 0),
//                       tween: Tween<double>(
//                         begin: isRecording ? 1 : 0,
//                         end: isRecording ? val.toDouble() + 1 : 0,
//                       ),
//                       curve: Curves.linear,
//                       builder: (context, value, _) {
//                         return Center(
//                           child: AnimatedContainer(
//                             duration: const Duration(milliseconds: 200),
//                             height: isRecording ? 90 : 30,
//                             width: isRecording ? 90 : 30,
//                             child: RecordingProgressIndicator(
//                               value: value,
//                               maxValue:
//                                   cameraBloc.recordDurationLimit.toDouble(),
//                             ),
//                           ),
//                         );
//                       });
//                 }),
//             Center(
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   AnimatedContainer(
//                     duration: const Duration(milliseconds: 200),
//                     curve: Curves.linear,
//                     height: isRecording ? 25 : 64,
//                     width: isRecording ? 25 : 64,
//                     decoration: BoxDecoration(
//                       color: ColorManager.backgroundColor,
//                       borderRadius: isRecording
//                           ? BorderRadius.circular(6)
//                           : BorderRadius.circular(100),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget errorWidget(CameraState state) {
//     bool isPermissionError =
//         state is CameraError && state.error == CameraErrorType.permission;
//     return Container(
//       color: Colors.black,
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               isPermissionError
//                   ? "يرجى منح حق الوصول إلى الكاميرا والميكروفون للمتابعة."
//                   : "حدث خطأ",
//               style: const TextStyle(
//                 color: Color(0xFF959393),
//                 fontFamily: "Montserrat",
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: CupertinoButton(
//                     padding: const EdgeInsets.symmetric(horizontal: 30),
//                     onPressed: () async {
//                       openAppSettings();
//                       Navigator.maybePop(context);
//                     },
//                     child: Container(
//                       height: 35,
//                       decoration: BoxDecoration(
//                         color: const Color.fromARGB(136, 76, 75, 75)
//                             .withOpacity(0.4),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Center(
//                         child: FittedBox(
//                           child: Text(
//                             "Open Setting",
//                             style: TextStyle(
//                               color: Colors.white.withOpacity(0.9),
//                               fontSize: 14,
//                               fontFamily: "Montserrat",
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
