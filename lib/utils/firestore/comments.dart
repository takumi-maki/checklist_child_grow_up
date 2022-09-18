import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../model/check_list.dart';
import '../../model/comment.dart';

class CommentFireStore {
  static final _firebaseFirestore = FirebaseFirestore.instance;
  static final CollectionReference comments = _firebaseFirestore.collection('messages');

  static Future<bool> addComment(CheckList checkList, Comment newComment) async {
    final CollectionReference collectionReference = _firebaseFirestore
        .collection('rooms').doc(checkList.roomId)
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
}