import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/utils/firestore/rooms.dart';
import 'package:flutter/material.dart';

import '../../model/check_list.dart';
import '../../model/comment.dart';

class CommentFireStore {
  static final _firebaseFirestore = FirebaseFirestore.instance;
  static final CollectionReference comments = _firebaseFirestore.collection('messages');

  static Future<bool> addComment(CheckList checkList, Comment newComment) async {
    final CollectionReference collectionReference = RoomFirestore.rooms.doc(checkList.roomId)
        .collection('check_lists').doc(checkList.id)
        .collection('comments');
    try {
      await collectionReference.add({
        'text': newComment.text,
        'item_id': newComment.itemId,
        'post_account_id': newComment.postAccountId,
        'created_time': newComment.createdTime
      });
      debugPrint('メッセージの作成完了');
      return true;
    } on FirebaseException catch(e) {
      debugPrint('メッセージの作成エラー: $e');
      return false;
    }
  }
  static Future deleteComments(Transaction transaction, DocumentReference checkListsDocRef) async {
    final CollectionReference commentsColRef = checkListsDocRef.collection('comments');
    var commentSnapshot = await commentsColRef.get();
    for (var comment in commentSnapshot.docs) {
      final DocumentReference commentsDocRef = checkListsDocRef
          .collection('comments').doc(comment.id);
      transaction.delete(commentsDocRef);
    }
  }
}