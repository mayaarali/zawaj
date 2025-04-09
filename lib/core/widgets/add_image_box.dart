import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/core/constants/image_manager.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/widgets/custom_text.dart';
import 'package:zawaj/core/constants/strings.dart';

import '../constants/dimensions.dart';

class AddImageBox extends StatelessWidget {
  const AddImageBox(
    this.height,
    this.width,
    this.path,
    this.onRemove,
    this.onAdd, {
    Key? key,
  }) : super(key: key);

  final double height, width;

  final String? path;
  final onRemove;
  final onAdd;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onAdd,
      child: path == null
          ? DottedBorder(
              color: ColorManager.primaryColor,
              strokeWidth: 2,
              dashPattern: const [6],
              borderType: BorderType.RRect,
              radius: const Radius.circular(8),
              child: Stack(
                children: [
                  SizedBox(
                    height: height,
                    width: width,
                    child: Center(
                      child: Image.asset(
                        ImageManager.addImageDefult,
                        width: context.width * 0.15,
                        height: context.height * 0.2,
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(
                      Icons.add_circle_outline,
                      color: Color(0xffB9B9B9),
                    ),
                  ),
                ],
              ),
            )
          : Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    color: const Color(0xffF1F4F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(path!),
                      fit: BoxFit.cover,
                      height: height,
                      width: width,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                      onTap: onRemove,
                      child: Image.asset(
                        ImageManager.galleryEdit,
                        width: 25,
                        height: 25,
                      )),
                ),
              ],
            ),
    );
  }
}

class AddImageBar extends StatelessWidget {
  const AddImageBar(
    this.desc,
    this.height,
    this.width,
    this.path,
    this.onRemove,
    this.onAdd, {
    super.key,
    this.isCamera,
  });

  final double height, width;
  final bool? isCamera;
  final String? path, desc;

  final onRemove;
  final onAdd;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onAdd,
      child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: const Color(0xffF1F4F9),
            borderRadius: BorderRadius.circular(Dimensions.buttonRadius),
          ),
          child: path == null
              ? Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.camera_alt_outlined,
                        color: ColorManager.primaryColor,
                      ),
                      const SizedBox(width: 8),
                      CustomText(
                        text: desc,
                        fontWeight: FontWeight.w700,
                      )
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.done_all_rounded,
                        color: ColorManager.primaryColor,
                      ),
                      const CustomText(
                        text: Strings.addedDone,
                        fontWeight: FontWeight.w700,
                      ),
                      //   SizedBox(width: 15),
                      const Spacer(),
                      GestureDetector(
                        onTap: onRemove,
                        child: const Icon(
                          Icons.highlight_remove,
                        ),
                      )
                    ],
                  ),
                )),
    );
  }
}
