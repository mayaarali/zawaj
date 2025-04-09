import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDialog extends StatelessWidget {
  final String? img;
  final bool visibility;
  final String? title;
  final String? desc;
  final Widget? action;
  const CustomDialog(
      {super.key, this.img, this.visibility = false, this.title = '', this.desc ,this.action});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Container(
            height: 335.h,
            decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(25.r)),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r)),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Image.asset(
                        img!,
                        width: 188.w,
                        height: 197.h,
                      )),
                  SizedBox(
                    height: 15.sp,
                  ),
                  Text(
                    title??"",
                    style:const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),

                  ),
                  SizedBox(
                    height: 15.sp,
                  ),
                  Visibility(
                      visible: visibility,
                      child: Text(
                        desc??"",
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                        textAlign: TextAlign.center,
                      )),
                  action??const SizedBox()

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}