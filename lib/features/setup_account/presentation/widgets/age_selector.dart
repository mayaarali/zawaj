import 'package:flutter/material.dart';
import 'package:zawaj/core/constants/color_manager.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/setup_bloc.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/widgets/custom_text.dart';

class AgeRangeSelector extends StatefulWidget {
  const AgeRangeSelector({super.key});

  @override
  State<AgeRangeSelector> createState() => _AgeRangeSelectorState();
}

class _AgeRangeSelectorState extends State<AgeRangeSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomText(
              text: Strings.ranged_age,
              color: ColorManager.darkGrey,
            ),
            CustomText(
              text:
                  '${SetUpBloc.get(context).selectedAgeRange.start.toInt()} - ${SetUpBloc.get(context).selectedAgeRange.end.toInt()}',
              color: ColorManager.darkGrey,
            ),
          ],
        ),
        RangeSlider(
          activeColor: ColorManager.primaryColor,
          inactiveColor: ColorManager.borderColor,
          values: SetUpBloc.get(context).selectedAgeRange,
          onChanged: (RangeValues values) {
            SetUpBloc.get(context).changeAgeRangeValue(values);
          },
          min: 17,
          max: 100,
          divisions: 73,
          labels: RangeLabels(
            SetUpBloc.get(context).selectedAgeRange.start.toInt().toString(),
            SetUpBloc.get(context).selectedAgeRange.end.toInt().toString(),
          ),
        ),
      ],
    );
  }
}
