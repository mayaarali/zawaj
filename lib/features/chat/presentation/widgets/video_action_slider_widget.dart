import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:action_slider/action_slider.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/features/chat/presentation/widgets/video_timer_widget.dart'; // Assuming you are using action_slider package

class VideoActionSliderWidget extends StatelessWidget {
  final ActionSliderController actionSliderController;
  final Future<void> Function() stopVideoRecording;
  final VoidCallback onRecordingStopped;

  const VideoActionSliderWidget({
    super.key,
    required this.actionSliderController,
    required this.stopVideoRecording,
    required this.onRecordingStopped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ActionSlider.standard(
          sliderBehavior: SliderBehavior.move,
          backgroundColor: ColorManager.primaryColor,
          toggleColor: Colors.white,
          direction: TextDirection.rtl,
          controller: actionSliderController,
          icon: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            child: SvgPicture.asset(ImageManager.videoLogo),
          ),
          action: (controller) async {
            await stopVideoRecording();
            onRecordingStopped();
            await Future.delayed(const Duration(seconds: 3));
          },
          child: const Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: 45),
                    Text(
                      'اسحب للالغاء',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ],
                ),
                VideoTimerWidget(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
