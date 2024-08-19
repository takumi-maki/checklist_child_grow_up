import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/function_utils.dart';

class AchievedDateWidget extends StatefulWidget {
  const AchievedDateWidget(
      {super.key, required this.birthDateTime, required this.achievedDateTime});

  final DateTime birthDateTime;
  final DateTime achievedDateTime;

  @override
  State<AchievedDateWidget> createState() => _AchievedDateWidgetState();
}

class _AchievedDateWidgetState extends State<AchievedDateWidget> {
  late int? ageMonths;

  @override
  Widget build(BuildContext context) {
    ageMonths = FunctionUtils.calculateAgeMonths(
        birthdate: widget.birthDateTime, targetDate: widget.achievedDateTime);
    return Row(
      children: [
        Text(
          '達成日:${DateFormat('yyyy.MM.dd').format(widget.achievedDateTime)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(width: 4),
        ageMonths != null
            ? Text('($ageMonthsヶ月)',
                style: Theme.of(context).textTheme.bodySmall)
            : const SizedBox()
      ],
    );
  }
}
