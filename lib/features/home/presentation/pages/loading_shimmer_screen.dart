import 'package:flutter/material.dart';
import 'package:zawaj/core/extensions/sizes.dart';
import 'package:zawaj/core/widgets/loading_shimmer.dart';

class LoadingHome extends StatelessWidget {
  const LoadingHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                return LoadingContainer(
                  height: context.height * 0.4,
                  width: double.infinity,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
