import 'package:flutter/material.dart';
import 'package:zawaj/core/constants/color_manager.dart';

class CustomRadios extends StatelessWidget {
  const CustomRadios(this.pageCount, {super.key});
  final int pageCount;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 15,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: 4,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) => Padding(
                padding: const EdgeInsets.all(3),
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                      color: pageCount == index
                          ? ColorManager.primaryColor
                          : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: ColorManager.primaryColor)),
                ),
              )),
    );
  }
}
