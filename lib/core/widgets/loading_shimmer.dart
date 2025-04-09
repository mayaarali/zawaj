import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// Container To Shimmer Loading That take Width and Height
class LoadingContainer extends StatelessWidget {
  final double? height;
  final double? width;
  const LoadingContainer({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Shimmer(
        gradient: LinearGradient(
          colors: [
            Colors.grey.withOpacity(0.7),
            Colors.grey.withOpacity(0.3),
            Colors.grey.withOpacity(0.5),
          ],
        ),
        child: Container(
          width: width ?? MediaQuery.of(context).size.width,
          height: height ?? MediaQuery.of(context).size.height * .225,
          // Add box decoration
          decoration: BoxDecoration(
            // Box decoration takes a gradient
            color: Colors.grey.withOpacity(.5),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
