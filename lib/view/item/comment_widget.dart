
import 'package:checklist_child_grow_up/utils/firestore/authentications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/comment.dart';
import '../../utils/firestore/rooms.dart';
import 'comment_detail_widget.dart';

class CommentWidget extends StatefulWidget {
  final String roomId;
  final String checkListId;
  final String itemId;
  final ScrollController scrollController;
  const CommentWidget({Key? key,
    required this.roomId,
    required this.checkListId,
    required this.itemId,
    required this.scrollController
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
                controller: widget.scrollController,
                itemCount: commentSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final Map<String, dynamic>? prevComment = (index > 0 ? commentSnapshot.data!.docs[index - 1].data() : null) as Map<String, dynamic>?;
                  final Timestamp? prevCommentCreatedTime = prevComment == null ? null : prevComment['created_time'];
                  Map<String, dynamic> data = commentSnapshot.data!.docs[index].data() as Map<String, dynamic>;
                  Comment comment = Comment(
                    text: data['text'],
                    imagePath: data['image_path'],
                    itemId: data['item_id'],
                    postAccountId: data['post_account_id'],
                    postAccountName: data['post_account_name'],
                    createdTime: data['created_time']
                  );
                  return CommentDetailWidget(
                    comment: comment,
                    prevCommentCreatedTime: prevCommentCreatedTime,
                    isMine: comment.postAccountId == currentFirebaseUser.uid
                  );
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

