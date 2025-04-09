import 'package:flutter/material.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/widgets/custom_text.dart';
import '../bloc/setup_bloc.dart';

class CustomisSmoking extends StatelessWidget {
  const CustomisSmoking({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Radio(
              // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

              //   title: const CustomText(text: Strings.yes),
              value: true,
              groupValue: SetUpBloc.get(context).setUpMap['IsSmoking'],
              onChanged: (value) {
                SetUpBloc.get(context)
                    .changeMapValue(key: "IsSmoking", value: value);
              },
            ),
            const CustomText(text: Strings.yes),
          ],
        ),
        Row(
          children: [
            Radio(
              //   title: const CustomText(text: Strings.no),
              value: false,
              groupValue: SetUpBloc.get(context).setUpMap['IsSmoking'],
              onChanged: (value) {
                SetUpBloc.get(context)
                    .changeMapValue(key: "IsSmoking", value: value);
              },
            ),
            const CustomText(text: Strings.no),
          ],
        ),
      ],
    );
  }
}
