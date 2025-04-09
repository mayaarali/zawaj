import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:zawaj/features/setup_account/presentation/bloc/setup_bloc.dart';

import '../../../../../core/constants/color_manager.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../data/models/params_model.dart';

class DateType extends StatelessWidget {
  DateType({
    super.key,
    Key? keyy,
    required this.i,
    required this.paramsList,
  });

  final int i;
  final List<ParamsModel> paramsList;

  @override
  Widget build(BuildContext context) {
    if (SetUpBloc.get(context).dropValueList![i] != null) {
      print(SetUpBloc.get(context).dropValueList![i] == null ||
          SetUpBloc.get(context).dropValueList![i] == null ||
          SetUpBloc.get(context).dropValueList![i]!.value == null ||
          SetUpBloc.get(context).dropValueList![i]!.value is List);
      print(SetUpBloc.get(context).dropValueList![i]!.value);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ExpandablePanel(
        theme: const ExpandableThemeData(
          iconColor: ColorManager.primaryColor,
        ),
        header: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              CustomText(
                text: paramsList[i].title,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ColorManager.borderColor,
              ),
            ],
          ),
        ),
        expanded: SizedBox(
          height: 300,
          child: Calendar(
            // startOnMonday: true,
            //weekDays: ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'],
            hideTodayIcon: true,
            hideBottomBar: true,
            showEvents: true,
            //todayColor: Colors.transparent,

            isExpandable: true,

            selectedColor: ColorManager.primaryColor,
            //selectedTodayColor: ColorManager.primaryColor,
            initialDate: SetUpBloc.get(context).dropValueList![i] == null ||
                    SetUpBloc.get(context).dropValueList![i] == null ||
                    SetUpBloc.get(context).dropValueList![i]!.value == null ||
                    SetUpBloc.get(context).dropValueList![i]!.value is List
                ? null
                : DateTime.tryParse(
                    SetUpBloc.get(context).dropValueList![i]!.value!),

            onDateSelected: (date) {
              debugPrint('dddddddddate');
              SetUpBloc.get(context).changeDropList(
                  i,
                  Value(id: null, value: date.toIso8601String()),
                  paramsList[i].id);
            },
            // locale: 'de_DE',
            // todayButtonText: 'Heute',
            // allDayEventText: 'Ganztägig',
            // multiDayEndText: 'Ende',
            isExpanded: true,
            expandableDateFormat: 'EEEE, dd. MMMM yyyy',
            datePickerType: DatePickerType.date,

            dayOfWeekStyle: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w800, fontSize: 11),
          ),
        ),
        collapsed: const SizedBox(),
      ),
    );
  }
}
