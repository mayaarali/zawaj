import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


Widget socialLoginWidget(String image) {
  return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PhysicalModel(
        color: Colors.white,
        elevation: 3.0,
        shape: BoxShape.circle,
        child: CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0x0fffffff),
          child: SvgPicture.asset(image),
        ),
      ));
}
