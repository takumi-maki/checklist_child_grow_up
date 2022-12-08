import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/check_list.dart';
import '../item/item_detail_page.dart';

class CheckListCardDetailWidget extends StatelessWidget {
  const CheckListCardDetailWidget({
    Key? key,
    required this.checkList,
    required this.item,
    required this.hasComments,
    this.unreadCommentsCount,
  }) : super(key: key);

  final CheckList checkList;
  final Item item;
  final bool hasComments;
  final int? unreadCommentsCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle,
              color: item.isAchieved
                ? Theme.of(context).colorScheme.secondary
                : Colors.grey.shade300
            ),
            const SizedBox(width: 16.0),
            Text('${item.month}ヶ月'),
          ],
        ),
        title: Text(item.content),
        subtitle: item.achievedTime != null
          ? Text(
            '達成した日:${DateFormat('yyyy年MM月dd日').format(item.achievedTime!.toDate())}',
            style: Theme.of(context).textTheme.bodySmall,
          )
          : null,
        trailing: hasComments
          ? Badge(
          showBadge: unreadCommentsCount! > 0,
          badgeContent: Text(
            unreadCommentsCount!.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 8.0)
          ),
          badgeColor: Theme.of(context).colorScheme.secondary,
          animationType: BadgeAnimationType.scale,
          child: const Icon(Icons.chat, color: Colors.black54)
        )
          : null,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
            ItemDetailPage(checkList: checkList, itemId: item.id),
          ));
        },
      ),
    );
  }
}