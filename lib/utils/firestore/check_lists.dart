import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/model/check_list.dart';
import 'package:checklist_child_grow_up/utils/firestore/comments.dart';
import 'package:checklist_child_grow_up/utils/firestore/rooms.dart';
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
  static Future updateHasCommentOfItem(WriteBatch batch, String newCommentItemId, CheckList checkList) async {
    List updatedItems = [];
    for (var item in checkList.items) {
      if(item.id == newCommentItemId) {
        updatedItems.add({
          'id': item.id,
          'month': item.month,
          'is_achieved': item.isAchieved,
          'content': item.content,
          'has_comment': true,
          'achieved_time': item.achievedTime
        });
      } else {
        updatedItems.add({
          'id': item.id,
          'month':item.month,
          'is_achieved': item.isAchieved,
          'content': item.content,
          'has_comment': item.hasComment,
          'achieved_time': item.achievedTime
        });
      }
    }
    final DocumentReference checkListDocRef = RoomFirestore.rooms.doc(checkList.roomId)
        .collection('check_lists').doc(checkList.id);
    batch.update(checkListDocRef, {
      'items': updatedItems,
    });
  }

  static Future<bool> updateItem(Item updatedItem,  CheckList checkList) async {
    try {
      DocumentReference<Map<String, dynamic>> documentReference = _firebaseFirestore
          .collection('rooms').doc(checkList.roomId)
          .collection('check_lists').doc(checkList.id);
      List updatedItems = [];
      await documentReference.get().then((doc){
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List itemList = data['items'];
        for (var item in itemList) {
          if(item['id'] == updatedItem.id) {
            updatedItems.add({
              'id': updatedItem.id,
              'month': updatedItem.month,
              'is_achieved': updatedItem.isAchieved,
              'content': updatedItem.content,
              'has_comment': updatedItem.hasComment,
              'achieved_time': updatedItem.achievedTime
            });
          } else {
            updatedItems.add({
              'id': item['id'],
              'month': item['month'],
              'is_achieved': item['is_achieved'],
              'content': item['content'],
              'has_comment': item['has_comment'],
              'achieved_time': item['achieved_time']
            });
          }
        }
      });
      await documentReference.update({
        'items': updatedItems,
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
      await CommentFireStore.deleteComments(batch, checkListsDocRef);
    }
  }
}

