import 'package:checklist_child_grow_up/model/check_list.dart';
import 'package:checklist_child_grow_up/view/item/item_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CheckListCardDetailWidget extends StatefulWidget {
  const CheckListCardDetailWidget({
    Key? key,
    required this.checkList,
    required this.item,
    required this.hasComment
  }) : super(key: key);

  final CheckList checkList;
  final Item item;
  final bool hasComment;

  @override
  State<CheckListCardDetailWidget> createState() => _CheckListCardDetailWidgetState();
}

class _CheckListCardDetailWidgetState extends State<CheckListCardDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle,
                color: widget.item.isAchieved ? Theme.of(context).colorScheme.secondary : Colors.grey.shade300
            ),
            const SizedBox(width: 16.0),
            Text('${widget.item.month}ヶ月'),
          ],
        ),
        title: Text(widget.item.content),
        subtitle: widget.item.achievedTime != null
          ? Text('達成した日: ${DateFormat('yyyy/MM/dd').format(widget.item.achievedTime!.toDate())}')
          : null,
        trailing: widget.hasComment ? const Icon(Icons.chat, color: Colors.black54) : null,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
            ItemDetailPage(checkList: widget.checkList, item: widget.item),
          ));
        },
      ),
    );
  }
}
