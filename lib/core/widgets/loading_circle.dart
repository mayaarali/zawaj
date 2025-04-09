import 'package:flutter/material.dart';
import 'package:zawaj/core/constants/color_manager.dart';
class LoadingCircle extends StatelessWidget {
  const LoadingCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Center(child: CircularProgressIndicator(color: ColorManager.primaryColor,));
  }
}
