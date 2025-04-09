import 'package:flutter/material.dart';
import 'package:zawaj/core/widgets/custom_scaffold.dart';

import '../../../../../core/widgets/custom_appbar.dart';
class ResendCode extends StatelessWidget {
  const ResendCode({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(child: Column(
      children: [
        CustomAppBar(isLogoTitle: true,),
        Placeholder(),
      ],
    ));
  }
}
