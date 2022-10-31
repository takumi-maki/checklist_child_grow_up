import 'package:checklist_child_grow_up/utils/firebase_storage/images.dart';
import 'package:checklist_child_grow_up/utils/firestore/check_lists.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/utils/firestore/rooms.dart';
import 'package:flutter/material.dart';

import '../../model/check_list.dart';
import '../../model/comment.dart';

class CommentFireStore {
  static final _firebaseFirestore = FirebaseFirestore.instance;

  static Future<bool> addComment(CheckList checkList, Comment newComment, bool itemHasComment) async {
    try {
      final batch = _firebaseFirestore.batch();
      final DocumentReference newCommentDoc = RoomFirestore.rooms.doc(checkList.roomId)
        .collection('check_lists').doc(checkList.id)
        .collection('comments').doc();
      batch.set(newCommentDoc, {
        'text': newComment.text,
        'image_path': newComment.imagePath,
        'item_id': newComment.itemId,
        'post_account_id': newComment.postAccountId,
        'post_account_name': newComment.postAccountName,
        'created_time': newComment.createdTime
      });
      if(!itemHasComment) {
        await CheckListFirestore.updateHasCommentOfItem(batch, newComment.itemId, checkList);
      }
      await batch.commit();
      debugPrint('メッセージの作成完了');
      return true;
    } on FirebaseException catch(e) {
      debugPrint('メッセージの作成エラー: $e');
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
      await ImageFirebaseStorage.deleteImage(data['image_path']);
    }
  }
}