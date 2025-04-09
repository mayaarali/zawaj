import 'package:flutter/material.dart';

import '../../core/constants/image_manager.dart';

class LogoImage extends StatelessWidget {
  const LogoImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ImageManager.logo,fit: BoxFit.fill,

    );
  }
}
