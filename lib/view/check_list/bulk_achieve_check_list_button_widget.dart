import 'package:flutter/material.dart';

import '../../model/check_list.dart';
import 'bulk_achieve_check_list_dialog.dart';

class BulkAchieveCheckListButtonWidget extends StatelessWidget {
  const BulkAchieveCheckListButtonWidget({required this.checkList, super.key});

  final CheckList checkList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 40.0,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: OutlinedButton.icon(
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return BulkAchieveCheckListDialog(checkList: checkList);
                    });
              },
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0))),
              icon: const Icon(
                Icons.edit_note,
                color: Colors.black87,
              ),
              label: Text('まとめて達成',
                  style: Theme.of(context).textTheme.titleSmall)),
        ));
  }
}
