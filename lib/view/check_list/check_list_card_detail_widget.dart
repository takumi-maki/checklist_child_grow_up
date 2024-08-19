import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';

import '../../model/check_list.dart';
import '../item/achieved_date_widget.dart';
import '../item/item_detail_page.dart';

class CheckListCardDetailWidget extends StatelessWidget {
  const CheckListCardDetailWidget({
    Key? key,
    required this.checkList,
    required this.item,
    required this.hasComments,
    required this.birthDateTime,
    this.unreadCommentsCount,
  }) : super(key: key);

  final CheckList checkList;
  final Item item;
  final bool hasComments;
  final DateTime birthDateTime;
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
                    : Colors.grey.shade300),
            const SizedBox(width: 16.0),
            Text('${item.month}ヶ月'),
          ],
        ),
        title: Text(item.content),
        subtitle: item.achievedTime == null
            ? null
            : AchievedDateWidget(
                birthDateTime: birthDateTime,
                achievedDateTime: item.achievedTime!.toDate(),
              ),
        trailing: hasComments
            ? badges.Badge(
                showBadge: unreadCommentsCount! > 0,
                badgeContent: Text(unreadCommentsCount!.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 8.0)),
                badgeStyle: badges.BadgeStyle(
                  badgeColor: Theme.of(context).colorScheme.secondary,
                ),
                badgeAnimation: const badges.BadgeAnimation.scale(),
                child: const Icon(Icons.chat, color: Colors.black54))
            : null,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ItemDetailPage(
                        checkList: checkList,
                        itemId: item.id,
                        birthDateTime: birthDateTime,
                      )));
        },
      ),
    );
  }
}
