import 'package:badges/badges.dart';
import 'package:checklist_child_grow_up/model/check_list.dart';
import 'package:checklist_child_grow_up/view/item/item_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/comment.dart';
import '../../utils/firestore/authentications.dart';
import '../../utils/firestore/rooms.dart';

class CheckListCardDetailWidget extends StatefulWidget {
  const CheckListCardDetailWidget({
    Key? key,
    required this.checkList,
    required this.item,
  }) : super(key: key);

  final CheckList checkList;
  final Item item;

  @override
  State<CheckListCardDetailWidget> createState() => _CheckListCardDetailWidgetState();
}

class _CheckListCardDetailWidgetState extends State<CheckListCardDetailWidget> {
  final User currentFirebaseUser = AuthenticationFirestore.currentFirebaseUser!;
  List<Comment>? comments;
  int unreadCommentsCount = 0;

  void setComments(List<QueryDocumentSnapshot> querySnapshot) {
    comments = querySnapshot.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Comment(
        id: data['id'],
        text: data['text'],
        imagePath: data['image_path'],
        itemId: data['item_id'],
        postedAccountId: data['posted_account_id'],
        postedAccountName: data['posted_account_name'],
        readAccountIds: data['read_account_ids'],
        createdTime: data['created_time']
      );
    }).toList();
  }

  void setUnreadCommentsCount() {
    final unreadComments = comments!.where((comment) =>
    !comment.readAccountIds.contains(currentFirebaseUser.uid));
    unreadCommentsCount = unreadComments.length;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: RoomFirestore.rooms.doc(widget.checkList.roomId)
        .collection('check_lists').doc(widget.checkList.id)
        .collection('comments').orderBy('created_time', descending: false)
        .where('item_id', isEqualTo: widget.item.id)
        .snapshots(),
      builder: (context, commentSnapshot) {
        if (!commentSnapshot.hasData) {
          return const SizedBox(
            height: 64.0,
            width: double.infinity,
          );
        }
        if (commentSnapshot.data!.docs.isNotEmpty) {
          setComments(commentSnapshot.data!.docs);
          setUnreadCommentsCount();
        }
        return Card(
          child: ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle,
                  color: widget.item.isAchieved
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.grey.shade300
                ),
                const SizedBox(width: 16.0),
                Text('${widget.item.month}ヶ月'),
              ],
            ),
            title: Text(widget.item.content),
            subtitle: widget.item.achievedTime != null
              ? Text('達成した日: ${DateFormat('yyyy/MM/dd').format(widget.item.achievedTime!.toDate())}')
              : null,
            trailing: comments != null
              ? Badge(
                showBadge: unreadCommentsCount > 0,
                badgeContent: Text(
                  unreadCommentsCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 8.0)
                ),
                badgeColor: Theme.of(context).colorScheme.secondary,
                animationType: BadgeAnimationType.scale,
                child: const Icon(Icons.chat, color: Colors.black54)
              )
              : null,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                ItemDetailPage(checkList: widget.checkList, item: widget.item, comments: comments),
              ));
            },
          ),
        );
      }
    );
  }
}
