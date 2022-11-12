import 'package:checklist_child_grow_up/model/check_list.dart';
import 'package:checklist_child_grow_up/utils/firestore/rooms.dart';
import 'package:checklist_child_grow_up/view/banner/ad_banner_widget.dart';
import 'package:checklist_child_grow_up/view/check_list/check_list_card_detail_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CheckListWidget extends StatefulWidget {
  final CheckList checkList;
  const CheckListWidget({Key? key, required this.checkList}) : super(key: key);

  @override
  State<CheckListWidget> createState() => _CheckListWidgetState();
}
class _CheckListWidgetState extends State<CheckListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.checkList.items.length,
        itemBuilder: (context, index) {
          Item item = Item(
              id: widget.checkList.items[index].id,
              month: widget.checkList.items[index].month,
              isAchieved: widget.checkList.items[index].isAchieved,
              content: widget.checkList.items[index].content,
              achievedTime: widget.checkList.items[index].achievedTime
          );
          return StreamBuilder<QuerySnapshot>(
              stream: RoomFirestore.rooms.doc(widget.checkList.roomId)
                  .collection('check_lists').doc(widget.checkList.id)
                  .collection('comments').orderBy('created_time', descending: false)
                  .where('item_id', isEqualTo: item.id)
                  .snapshots(),
              builder: (context, commentSnapshot) {
                if (!commentSnapshot.hasData) {
                  return const SizedBox();
                }
                return Column(
                  children: [
                    index != 0 && index % 7 == 0 ? const AdBannerWidget() : const SizedBox(),
                    CheckListCardDetailWidget(
                      checkList: widget.checkList,
                      item: item,
                      hasComment: commentSnapshot.data!.docs.isNotEmpty
                    )
                  ],
                );
              });
        }
    );
  }
}

