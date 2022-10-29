
import 'package:checklist_child_grow_up/utils/firestore/authentications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/comment.dart';
import '../../utils/firestore/rooms.dart';
import 'my_comment_widget.dart';
import 'someone_comment_widget.dart';
class CommentWidget extends StatefulWidget {
  final String roomId;
  final String checkListId;
  final String itemId;
  const CommentWidget({Key? key,
    required this.roomId,
    required this.checkListId,
    required this.itemId,
  }) : super(key: key);

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final User currentFirebaseUser = AuthenticationFirestore.currentFirebaseUser!;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: RoomFirestore.rooms.doc(widget.roomId)
              .collection('check_lists').doc(widget.checkListId)
              .collection('comments').orderBy('created_time', descending: false).where('item_id', isEqualTo: widget.itemId)
              .snapshots(),
          builder: (context, commentSnapshot) {
            if(commentSnapshot.hasData) {
              if (commentSnapshot.data!.docs.isEmpty) {
                return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Text('コメントはまだありません')
                );
              }
              return ListView.builder(
                itemCount: commentSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = commentSnapshot.data!.docs[index].data() as Map<String, dynamic>;
                  Comment comment = Comment(
                    text: data['text'],
                    imagePath: data['image_path'],
                    itemId: data['item_id'],
                    postAccountId: data['post_account_id'],
                    postAccountName: data['post_account_name'],
                    createdTime: data['created_time']
                  );
                  return comment.postAccountId == currentFirebaseUser.uid
                    ? MyCommentWidget(comment: comment)
                    : SomeOneCommentWidget(comment: comment);
                }
              );
            } else {
              return const SizedBox();
            }
          }
      ),
    );
  }
}

