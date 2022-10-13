import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/model/check_list.dart';
import 'package:checklist_child_grow_up/utils/firestore/comments.dart';
import 'package:checklist_child_grow_up/utils/firestore/rooms.dart';
import 'package:flutter/material.dart';


class CheckListFirestore {
  static final _firebaseFirestore = FirebaseFirestore.instance;

  static Future<bool> setCheckList(int index, String roomId, List<dynamic> items) async {
    final DocumentReference roomCheckLists = _firebaseFirestore
        .collection('rooms').doc(roomId)
        .collection('check_lists').doc();
    String newDocId = roomCheckLists.id;
    try {
      await roomCheckLists.set({
        'id': newDocId,
        'type': index,
        'room_id': roomId,
        'items': items,
      });
      return true;
    } on FirebaseException catch(e){
      debugPrint('チェックリスト作成エラー : $e');
      return false;
    }
  }

  static Future<bool> updateItem(Item updateItem,  CheckList checkList) async {
    try {
      DocumentReference<Map<String, dynamic>> documentReference = _firebaseFirestore
          .collection('rooms').doc(checkList.roomId)
          .collection('check_lists').doc(checkList.id);
      List items = [];
      await documentReference.get().then((doc){
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List itemList = data['items'];
        for (var item in itemList) {
          if(item['id'] == updateItem.id) {
            items.add({
              'id': updateItem.id,
              'month': updateItem.month,
              'is_complete': updateItem.isComplete,
              'content': updateItem.content,
              'has_comment': updateItem.hasComment,
              'completed_time': updateItem.completedTime
            });
          } else {
            items.add({
              'id': item['id'],
              'month': item['month'],
              'is_complete': item['is_complete'],
              'content': item['content'],
              'has_comment': item['has_comment'],
              'completed_time': item['completed_time']
            });
          }
        }
      });
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
  static Future deleteCheckLists(Transaction transaction, DocumentReference roomsDocRef) async {
    final checkListsSnapshot = await roomsDocRef.collection('check_lists').get();
    for (var checkList in checkListsSnapshot.docs) {
      final DocumentReference checkListsDocRef = roomsDocRef.collection(
          'check_lists').doc(checkList.id);
      transaction.delete(checkListsDocRef);
      await CommentFireStore.deleteComments(transaction, checkListsDocRef);
    }
  }
}

