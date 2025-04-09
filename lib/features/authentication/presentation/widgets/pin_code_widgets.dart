import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import '../../../../core/constants/color_manager.dart';

class PinCodeWidget extends StatelessWidget {
  const PinCodeWidget({super.key, this.controller});
  final dynamic controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: PinCodeTextField(
          autoDisposeControllers: false,
          textStyle: const TextStyle(color: ColorManager.primaryColor),
          controller: controller,
          length: 6,
          obscureText: false,
          animationType: AnimationType.fade,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            FilteringTextInputFormatter.digitsOnly
          ],

          pinTheme: PinTheme(
            inactiveBorderWidth: 1.2,

            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            selectedColor: ColorManager.primaryColor,
            inactiveColor: ColorManager.primaryColor,
            fieldHeight: MediaQuery.of(context).size.height * 0.06,
            fieldWidth: MediaQuery.of(context).size.width * 0.120,
            fieldOuterPadding: EdgeInsets.all(2),
            activeFillColor: ColorManager.whiteTextColor,
            activeColor: ColorManager.primaryColor,
            selectedFillColor: ColorManager.whiteTextColor,
            inactiveFillColor: ColorManager.whiteTextColor,
            // borderWidth: 10
          ),
          animationDuration: const Duration(milliseconds: 300),
          backgroundColor: ColorManager.whiteTextColor,
          enableActiveFill: true,

          //   errorAnimationController: errorController,
          // controller: textEditingController,
          onCompleted: (v) {
            debugPrint("Completed");
          },
          onChanged: (value) {
            debugPrint(value);
          },
          beforeTextPaste: (text) {
            debugPrint("Allowing to paste $text");
            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
            //but you can show anything you want here, like your pop up saying wrong paste format or etc
            return true;
          },
          appContext: context,
        ),
      ),
    );
  }
}
