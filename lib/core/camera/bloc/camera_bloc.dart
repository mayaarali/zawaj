import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawaj/core/camera/bloc/camera_state.dart';
import 'package:zawaj/core/camera/enums/camera_enums.dart';
import 'package:zawaj/core/camera/utlis/camera_utils.dart';
import 'package:zawaj/core/camera/utlis/permission_utils.dart';
part 'camera_event.dart';

// A BLoC class that handles camera-related operations
class CameraBloc extends Bloc<CameraEvent, CameraState> {
  //....... Dependencies ..............
  final CameraUtils cameraUtils;
  final PermissionUtils permissionUtils;
  bool _isBlocClosed = false;
  bool _isClosed = false;

  //....... Internal variables ........
  int recordDurationLimit = 15;
  CameraController? _cameraController;
  CameraLensDirection currentLensDirection = CameraLensDirection.back;
  Timer? recordingTimer;
  ValueNotifier<int> recordingDuration = ValueNotifier(0);

  //....... Getters ..........
  CameraController? getController() => _cameraController;
  bool isInitialized() => _cameraController?.value.isInitialized ?? false;
  bool isRecording() => _cameraController?.value.isRecordingVideo ?? false;

  //setters
  set setRecordDurationLimit(int val) {
    recordDurationLimit = val;
  }

  //....... Constructor ........
  CameraBloc({required this.cameraUtils, required this.permissionUtils})
      : super(CameraInitial()) {
    on<CameraReset>(_onCameraReset);
    on<CameraInitialize>(_onCameraInitialize);
    on<CameraSwitch>(_onCameraSwitch);
    on<CameraRecordingStart>(_onCameraRecordingStart);
    on<CameraRecordingStop>(_onCameraRecordingStop);
    on<CameraEnable>(_onCameraEnable);
    on<CameraDisable>(_onCameraDisable);
  }

  // ...................... event handler ..........................

  // Handle CameraReset event
  void _onCameraReset(CameraReset event, Emitter<CameraState> emit) async {
    if (!_isClosed) {
      await _disposeCamera();
      _resetCameraBloc();
      emit(CameraInitial());
    }
  }

  // Handle CameraInitialize event
  void _onCameraInitialize(
      CameraInitialize event, Emitter<CameraState> emit) async {
    if (!_isClosed) {
      recordDurationLimit = event.recordingLimit;
      try {
        await _checkPermissionAndInitializeCamera();
        if (_cameraController != null) {
          emit(CameraReady(isRecordingVideo: false));
        } else {
          emit(CameraError(error: CameraErrorType.other));
        }
      } catch (e) {
        emit(CameraError(
            error: e == CameraErrorType.permission
                ? CameraErrorType.permission
                : CameraErrorType.other));
      }
    }
  }

  // Handle CameraSwitch event
  void _onCameraSwitch(CameraSwitch event, Emitter<CameraState> emit) async {
    emit(CameraInitial());
    await _switchCamera();
    emit(CameraReady(isRecordingVideo: false));
  }

  // Handle CameraRecordingStart event
  void _onCameraRecordingStart(
      CameraRecordingStart event, Emitter<CameraState> emit) async {
    if (!isRecording()) {
      try {
        emit(CameraReady(isRecordingVideo: true));
        await _startRecording();
      } catch (e) {
        await _reInitialize();
        emit(CameraReady(isRecordingVideo: false));
      }
    }
  }

  // Handle CameraRecordingStop event
  void _onCameraRecordingStop(
      CameraRecordingStop event, Emitter<CameraState> emit) async {
    if (isRecording()) {
      // Check if the recorded video duration is less than 3 seconds to prevent
      // potential issues with very short videos resulting in corrupt files.
      bool hasRecordingLimitError = recordingDuration.value < 2 ? true : false;
      emit(CameraReady(
          isRecordingVideo: false,
          hasRecordingError: hasRecordingLimitError,
          decativateRecordButton: true));
      File? videoFile;
      try {
        videoFile =
            await _stopRecording(); // Stop video recording and get the recorded video file
        if (hasRecordingLimitError) {
          await Future.delayed(const Duration(milliseconds: 1500),
              () {}); // To prevent rapid consecutive clicks, we introduce a debounce delay of 2 seconds,
          emit(CameraReady(
              isRecordingVideo: false,
              hasRecordingError: false,
              decativateRecordButton: false));
        } else {
          emit(CameraRecordingSuccess(file: videoFile));
        }
      } catch (e) {
        await _reInitialize(); // On Camera Exception, initialize the camera again
        emit(CameraReady(isRecordingVideo: false));
      }
    }
  }

  // Handle CameraEnable event on app resume
  void _onCameraEnable(CameraEnable event, Emitter<CameraState> emit) async {
    if (!isInitialized() && _cameraController != null) {
      if (await permissionUtils.getCameraAndMicrophonePermissionStatus()) {
        await _initializeCamera();
        emit(CameraReady(isRecordingVideo: false));
      } else {
        emit(CameraError(error: CameraErrorType.permission));
      }
    }
  }

  // Handle CameraDisable event when camera is not in use
  void _onCameraDisable(CameraDisable event, Emitter<CameraState> emit) async {
    if (isInitialized() && isRecording()) {
      // if app minimize while recording then save the the video then disable the camera
      add(CameraRecordingStop());
      await Future.delayed(const Duration(seconds: 2));
    }
    await _disposeCamera();
    emit(CameraInitial());
  }

  // ................... Other methods ......................

  // Reset the camera BLoC to its initial state
  void _resetCameraBloc() {
    _cameraController = null;
    currentLensDirection = CameraLensDirection.front;
    _stopTimerAndResetDuration();
  }

  // Start the recording timer
  void _startTimer() async {
    recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      recordingDuration.value++;
      if (recordingDuration.value == recordDurationLimit) {
        add(CameraRecordingStop());
      }
    });
  }

  // Stop the recording timer and reset the duration
  void _stopTimerAndResetDuration() async {
    recordingTimer?.cancel();
    recordingDuration.value = 0;
  }

  // Start video recording
  Future<void> _startRecording() async {
    try {
      await _cameraController!.startVideoRecording();
    } catch (e) {
      return Future.error(e);
    }
  }

  // Stop video recording and return the recorded video file
  Future<File> _stopRecording() async {
    try {
      XFile video = await _cameraController!.stopVideoRecording();
      _stopTimerAndResetDuration();
      return File(video.path);
    } catch (e) {
      return Future.error(e);
    }
  }

  // Check and ask for camera permission and initialize camera
  Future<void> _checkPermissionAndInitializeCamera() async {
    if (await permissionUtils.getCameraAndMicrophonePermissionStatus()) {
      await _initializeCamera();
    } else {
      if (await permissionUtils.askForPermission()) {
        await _initializeCamera();
      } else {
        return Future.error(CameraErrorType
            .permission); // Throw the specific error type for permission denial
      }
    }
  }

  // Initialize the camera controller
  Future<void> _initializeCamera() async {
    _cameraController = await cameraUtils.getCameraController(
        lensDirection: currentLensDirection);
    try {
      // Check if the controller is not null before using it
      if (_cameraController != null) {
        await _cameraController!.initialize();
        _cameraController!.addListener(() {
          if (_cameraController!.value.isRecordingVideo) {
            _startTimer();
          }
        });
      }
    } on CameraException catch (error) {
      throw error; // Rethrow the specific error
    } catch (e) {
      throw e; // Rethrow other exceptions
    }
  }

  // Switch between front and back cameras
  Future<void> _switchCamera() async {
    currentLensDirection = currentLensDirection == CameraLensDirection.back
        ? CameraLensDirection.front
        : CameraLensDirection.back;
    await _reInitialize();
  }

  // Reinitialize the camera
  Future<void> _reInitialize() async {
    await _disposeCamera();
    await _initializeCamera();
  }

  // Dispose of the camera controller
  Future<void> _disposeCamera() async {
    if (_cameraController != null) {
      _cameraController!.removeListener(() {});
      await _cameraController!.dispose();
      _stopTimerAndResetDuration();
      _cameraController = await cameraUtils.getCameraController(
          lensDirection: currentLensDirection);
    }
  }

  @override
  Future<void> close() {
    _isClosed = true;
    return super.close();
  }
}
