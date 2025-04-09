import 'package:flutter/material.dart';

Widget dropDownWidget(
    {dynamic size,
    required bool withOutArrow,
    required bool border,
    required String title,
    required bool isLanguge,
    dynamic icon}) {
  return Container(
    padding: const EdgeInsets.all(8),
    width: size.width,
    height: 54,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: border ? Border.all(color: const Color(0xffD8D8D8)) : null,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xff0D3D5E),
            foregroundColor: const Color(0XFFFFFFFF),
            child: isLanguge ? icon : null,
            backgroundImage: isLanguge ? null : icon,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(color: Color(0xff0D1B1E), fontSize: 16),
            ),
          )
        ]),
        !withOutArrow
            ? const Icon(
                Icons.arrow_drop_down,
                color: Color(0XFF999999),
              )
            : const SizedBox()
      ],
    ),
  );
}
