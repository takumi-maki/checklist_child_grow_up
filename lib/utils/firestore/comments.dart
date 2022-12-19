import 'package:checklist_child_grow_up/utils/firebase_storage/images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/utils/firestore/rooms.dart';
import 'package:flutter/material.dart';

import '../../model/check_list.dart';
import '../../model/comment.dart';

class CommentFirestore {
  static Future<bool> setNewComment(CheckList checkList, Comment newComment) async {
    try {
      final DocumentReference newCommentDoc = RoomFirestore.rooms.doc(checkList.roomId)
        .collection('check_lists').doc(checkList.id)
        .collection('comments').doc(newComment.id);
      await newCommentDoc.set({
        'id': newComment.id,
        'text': newComment.text,
        'image_path': newComment.imagePath,
        'item_id': newComment.itemId,
        'posted_account_id': newComment.postedAccountId,
        'read_account_ids': newComment.readAccountIds,
        'created_time': newComment.createdTime
      });
      debugPrint('メッセージの作成完了');
      return true;
    } on FirebaseException catch(e) {
      debugPrint('メッセージの作成エラー: $e');
      return false;
    }
  }

  static Future<bool> updateComment(String roomId, String checkListId, Comment updatedComment) async {
    try {
      final DocumentReference commentDoc = RoomFirestore.rooms.doc(roomId)
          .collection('check_lists').doc(checkListId)
          .collection('comments').doc(updatedComment.id);
      await commentDoc.set({
        'id': updatedComment.id,
        'text': updatedComment.text,
        'image_path': updatedComment.imagePath,
        'item_id': updatedComment.itemId,
        'posted_account_id': updatedComment.postedAccountId,
        'read_account_ids': updatedComment.readAccountIds,
        'created_time': updatedComment.createdTime
      });
      debugPrint('コメント情報更新完了');
      return true;
    } on FirebaseException catch(e) {
      debugPrint('コメント情報更新エラー: $e');
      return false;
    }
  }

  static Future deleteComments(WriteBatch batch, DocumentReference checkListsDocRef) async {
    final CollectionReference commentsColRef = checkListsDocRef.collection('comments');
    var commentSnapshot = await commentsColRef.get();
    for (var comment in commentSnapshot.docs) {
      final DocumentReference commentsDocRef = checkListsDocRef
          .collection('comments').doc(comment.id);
      batch.delete(commentsDocRef);
      Map<String, dynamic> data = comment.data() as Map<String, dynamic>;
      if (data['image_path'] == null) continue;
      await ImageFirebaseStorage.deleteImage(data['image_path']);
    }
  }
}