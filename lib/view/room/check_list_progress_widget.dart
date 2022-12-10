import 'package:flutter/material.dart';

import '../../model/check_list.dart';

class CheckListProgressWidget extends StatelessWidget {
  const CheckListProgressWidget({
    Key? key,
    required this.title,
    required this.checkListProgress
  }) : super(key: key);

  final String title;
  final CheckListProgress checkListProgress;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: const TextStyle(fontSize: 14.0)),
        Text(
          '${checkListProgress.isAchievedItemsCount} / ${checkListProgress.totalItemsCount}',
          style: const TextStyle(fontSize: 14.0)
        ),
      ],
    );
  }
}