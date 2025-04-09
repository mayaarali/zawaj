import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zawaj/core/constants/dimensions.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import '../../core/constants/color_manager.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final Color? hintTextColor;
  final String? labelText;
  final FormFieldSetter? onSaved;
  final FormFieldValidator? validate;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscure;
  final TextEditingController? controller;
  final TextAlign? textAlign;
  final bool? readonly;
  final TextInputType? keyboardType;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final int? maxLines;
  final bool hasPrefix;
  final double? height;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField(
      {super.key,
      this.inputFormatters,
      this.hintText,
      this.onSaved,
      this.validate,
      this.obscure = false,
      this.prefixIcon,
      this.readonly = false,
      this.controller,
      this.labelText,
      this.hasPrefix = false,
      this.maxLines,
      this.suffixIcon,
      this.textAlign,
      this.keyboardType,
      this.onTap,
      this.onFieldSubmitted,
      this.onChanged,
      this.height,
      this.hintTextColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.only(top: 10),
      height: height ?? Dimensions(context: context).textFieldHeight,
      decoration: BoxDecoration(
          border: Border.all(color: ColorManager.hintTextColor),
          color: ColorManager.whiteTextColor,
          borderRadius: BorderRadius.circular(Dimensions.buttonRadius)),
      child: Center(
        child: TextFormField(
            inputFormatters: [
              ...?inputFormatters,
              ArabicToEnglishNumberFormatter(),
            ],
            maxLines: maxLines ?? 1,
            onFieldSubmitted: onFieldSubmitted,
            onChanged: onChanged,
            controller: controller,
            obscureText: obscure,
            // obscuringCharacter: '●',
            ////  style: const TextStyle( color: ColorManager.primaryColor, ),
            onSaved: onSaved,
            validator: validate,
            autofocus: false,
            onTap: onTap,
            readOnly: readonly!,
            keyboardType: keyboardType,
            textAlign: textAlign ?? TextAlign.start,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              errorStyle: const TextStyle(
                fontSize: 10, //height: 1.5
                //0.042
              ),
              prefixIcon: hasPrefix
                  ? SizedBox(
                      width: 80,
                      child: Icon(
                        prefixIcon,
                        color: ColorManager.hintTextColor,
                      ),
                    )
                  : null,
              suffixIcon: suffixIcon,
              hintText: hintText,
              labelStyle:
                  TextStyle(color: hintTextColor ?? ColorManager.hintTextColor
                      // fontSize: 16,
                      ),
              hintStyle: const TextStyle(
                  color: ColorManager.hintTextColor, fontSize: 15),
              labelText: labelText,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.only(
                  right: 20,
                  left: 20,
                  top: suffixIcon == null ? 0 : context.height * 0.015),
              border: InputBorder.none,
            )),
      ),
    );
  }
}

class ArabicToEnglishNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAllMapped(
      RegExp(r'[٠١٢٣٤٥٦٧٨٩]'),
      (Match match) {
        const arabicToEnglishMap = {
          '٠': '0',
          '١': '1',
          '٢': '2',
          '٣': '3',
          '٤': '4',
          '٥': '5',
          '٦': '6',
          '٧': '7',
          '٨': '8',
          '٩': '9',
        };
        return arabicToEnglishMap[match.group(0)!]!;
      },
    );

    return newValue.copyWith(
      text: newText,
      selection: newValue.selection,
    );
  }
}
