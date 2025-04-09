import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyPage extends StatelessWidget {
  final String? text;
  final String? svg;
  const EmptyPage({super.key, this.text, this.svg});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * .8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            svg!.endsWith('svg')
                ?
            SvgPicture.asset(
              svg ?? '',
              height: 200,
              width: 200,
            //  color: ColorManager.primaryColor,
            )
                :
            Image.asset(
              svg ?? '',
              height: 200,
              width: 200,
              scale: 1.2,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              text ?? '',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )
            ),
          ],
        ));
  }
}
