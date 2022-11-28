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
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title),
          Text('${checkListProgress.isAchievedItemsCount} / ${checkListProgress.totalItemsCount}'),
        ],
      ),
    );
  }
}