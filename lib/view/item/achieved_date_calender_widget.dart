import 'package:checklist_child_grow_up/utils/function_utils.dart';
import 'package:checklist_child_grow_up/view/item/achieved_date_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../model/check_list.dart';
import '../../utils/firestore/check_lists.dart';
import '../widget_utils/snack_bar/error_snack_bar_widget.dart';

class AchievedDateCalenderWidget extends StatefulWidget {
  final CheckList checkList;
  final Item item;
  final DateTime birthDateTime;
  final DateTime achievedDateTime;

  const AchievedDateCalenderWidget(
      {Key? key,
      required this.checkList,
      required this.item,
      required this.birthDateTime,
      required this.achievedDateTime})
      : super(key: key);

  @override
  State<AchievedDateCalenderWidget> createState() =>
      _AchievedDateCalenderWidgetState();
}

class _AchievedDateCalenderWidgetState
    extends State<AchievedDateCalenderWidget> {
  final DateTime currentTime = DateTime.now();

  Future<Timestamp?> modifyAchievedTime(DateTime achievedDate) async {
    final DateTime? pickedDate = await FunctionUtils.pickDateFromDatePicker(
      context: context,
      initialDate: achievedDate,
      firstDate: widget.birthDateTime,
      lastDate: currentTime,
    );
    if (pickedDate != null && pickedDate != achievedDate) {
      return Timestamp.fromDate(pickedDate);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final Timestamp? modifiedAchievedTime =
            await modifyAchievedTime(widget.item.achievedTime!.toDate());
        if (modifiedAchievedTime == null) return;
        if (currentTime.isBefore(modifiedAchievedTime.toDate())) {
          if (!mounted) return;
          final dateErrorSnackBar =
              ErrorSnackBar(context, title: '達成した日は本日以前で修正してください');
          ScaffoldMessenger.of(context).showSnackBar(dateErrorSnackBar);
          return;
        }
        final List<Item> updatedItems = widget.checkList.items.map((item) {
          return item.id == widget.item.id
              ? Item(
                  id: widget.item.id,
                  month: widget.item.month,
                  isAchieved: widget.item.isAchieved,
                  content: widget.item.content,
                  achievedTime: modifiedAchievedTime)
              : Item(
                  id: item.id,
                  month: item.month,
                  isAchieved: item.isAchieved,
                  content: item.content,
                  achievedTime: item.achievedTime);
        }).toList();
        var updateItemsResult = await CheckListFirestore.updateItems(
            updatedItems, widget.checkList);
        if (!updateItemsResult) {
          if (!mounted) return;
          final updateErrorSnackBar =
              ErrorSnackBar(context, title: '達成した日の更新に失敗しました');
          ScaffoldMessenger.of(context).showSnackBar(updateErrorSnackBar);
          return;
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: AchievedDateWidget(
                  birthDateTime: widget.birthDateTime,
                  achievedDateTime: widget.achievedDateTime)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(Icons.edit_calendar, size: 18.0, color: Colors.black54),
          )
        ],
      ),
    );
  }
}
