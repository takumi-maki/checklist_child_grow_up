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
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: achievedDate,
      firstDate: DateTime.now().add(const Duration(days: - 3650)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.orange.shade300,
              onSurface: Colors.black87
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Theme.of(context).colorScheme.secondary
              ),
            ),
          ),
          child: child!,
        );
      }
    );
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
          Text('達成した日 ： ${DateFormat('yyyy/MM/dd').format(widget.item.achievedTime!.toDate())}',
            style: const TextStyle(color: Colors.black54),
          ),
          IconButton(
            onPressed: () async {
              final Timestamp? modifiedAchievedTime = await modifyAchievedTime(widget.item.achievedTime!.toDate());
              if (modifiedAchievedTime == null) return;
              if (currentTime.isBefore(modifiedAchievedTime.toDate())) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                    WidgetUtils.errorSnackBar('達成した日は本日以前に修正してください')
                );
                return;
              }
              Item updatedItem = Item(
                id: widget.item.id,
                month: widget.item.month,
                isAchieved: widget.item.isAchieved,
                content: widget.item.content,
                hasComment: widget.item.hasComment,
                achievedTime: modifiedAchievedTime,
              );
              var result = await CheckListFirestore.updateItem(updatedItem, widget.checkList);
              if (!result) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                    WidgetUtils.errorSnackBar('達成した日の更新に失敗しました')
                );
                return;
              }
              setState(() {
                widget.item.achievedTime = modifiedAchievedTime;
              });
            },
            icon: const Icon(Icons.edit_calendar, size: 18.0, color: Colors.black54))
        ],
      ),
    );
  }
}
