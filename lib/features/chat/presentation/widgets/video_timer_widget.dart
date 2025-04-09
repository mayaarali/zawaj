import 'package:flutter/material.dart';

class VideoTimerWidget extends StatelessWidget {
  const VideoTimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<int>(
        stream: Stream.periodic(const Duration(seconds: 1), (i) => i),
        builder: (context, snapshot) {
          Duration duration = Duration(seconds: snapshot.data ?? 0);
          String formattedTime = _formatDuration(duration);
          return Row(
            children: [
              Text(
                formattedTime,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              const Icon(
                Icons.fiber_manual_record_sharp,
                color: Colors.white,
                size: 20,
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    String formattedTime = '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
    return formattedTime;
  }
}
