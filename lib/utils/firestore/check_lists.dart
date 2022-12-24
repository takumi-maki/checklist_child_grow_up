import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/model/check_list.dart';
import 'package:checklist_child_grow_up/utils/firestore/comments.dart';
import 'package:flutter/material.dart';


class CheckListFirestore {
  static final _firebaseFirestore = FirebaseFirestore.instance;

  static Future setNewCheckLists(WriteBatch batch, CheckListType type, String roomId, List newItems) async {
    final DocumentReference checkListsDocRef = _firebaseFirestore
        .collection('rooms').doc(roomId)
        .collection('check_lists').doc();
    batch.set(checkListsDocRef, {
      'id': checkListsDocRef.id,
      'type': checkListTypeToInt(type),
      'room_id': roomId,
      'items': newItems,
    });
  }
  static Future<bool> updateItems(List<Item> updatedItems,  CheckList checkList) async {
    try {
      DocumentReference<Map<String, dynamic>> documentReference = _firebaseFirestore
          .collection('rooms').doc(checkList.roomId)
          .collection('check_lists').doc(checkList.id);
      List items = updatedItems.map((item) {
        return {
          'id': item.id,
          'month': item.month,
          'is_achieved': item.isAchieved,
          'content': item.content,
          'achieved_time': item.achievedTime
        };
      }).toList();
      await documentReference.update({
        'items': items,
      });
      debugPrint('チェックリストアイテム更新完了');
      return true;
    } on FirebaseException catch(e) {
      debugPrint('チェックリストアイテム更新エラー: $e');
      return false;
    }
  }
  static Future deleteCheckLists(WriteBatch batch, DocumentReference roomsDocRef) async {
    final checkListsSnapshot = await roomsDocRef.collection('check_lists').get();
    for (var checkList in checkListsSnapshot.docs) {
      final DocumentReference checkListsDocRef = roomsDocRef.collection(
          'check_lists').doc(checkList.id);
      batch.delete(checkListsDocRef);
      await CommentFirestore.deleteComments(batch, checkListsDocRef);
    }
  }
}

