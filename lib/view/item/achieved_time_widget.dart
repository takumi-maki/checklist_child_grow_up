import 'package:checklist_child_grow_up/utils/function_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/check_list.dart';
import '../../utils/firestore/check_lists.dart';
import '../../utils/widget_utils.dart';

class AchievedTimeWidget extends StatefulWidget {
  final CheckList checkList;
  final Item item;
  const AchievedTimeWidget({Key? key, required this.checkList, required this.item}) : super(key: key);

  @override
  State<AchievedTimeWidget> createState() => _AchievedTimeWidgetState();
}

class _AchievedTimeWidgetState extends State<AchievedTimeWidget> {
  final DateTime currentTime = DateTime.now();

  Future<Timestamp?> modifyAchievedTime(DateTime achievedDate) async {
    final DateTime? pickedDate = await FunctionUtils.pickDateFromDatePicker(context, achievedDate);
    if (pickedDate != null && pickedDate != achievedDate) {
      return Timestamp.fromDate(pickedDate);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('達成した日 ： ${DateFormat('yyyy年MM月dd日').format(widget.item.achievedTime!.toDate())}',
            style: const TextStyle(color: Colors.black54),
          ),
          IconButton(
            onPressed: () async {
              final Timestamp? modifiedAchievedTime = await modifyAchievedTime(widget.item.achievedTime!.toDate());
              if (modifiedAchievedTime == null) return;
              if (currentTime.isBefore(modifiedAchievedTime.toDate())) {
                if (!mounted) return;
                WidgetUtils.errorSnackBar(context, '達成した日は本日以前で修正してください');
                return;
              }
              Item updatedItem = Item(
                id: widget.item.id,
                month: widget.item.month,
                isAchieved: widget.item.isAchieved,
                content: widget.item.content,
                achievedTime: modifiedAchievedTime,
              );
              var result = await CheckListFirestore.updateItem(updatedItem, widget.checkList);
              if (!result) {
                if (!mounted) return;
                WidgetUtils.errorSnackBar(context, '達成した日の更新に失敗しました');
                return;
              }
            },
            icon: const Icon(Icons.edit_calendar, size: 18.0, color: Colors.black54))
        ],
      ),
    );
  }
}
