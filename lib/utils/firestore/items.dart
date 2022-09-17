import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_sns_app/utils/firestore/check_lists.dart';
import 'package:flutter/material.dart';

import '../../model/check_list.dart';

class ItemFireStore {
  static final _firebaseFirestore = FirebaseFirestore.instance;
  static final CollectionReference items = _firebaseFirestore.collection('items');


  static Future<bool> setMultipleItem(List items, String roomId, String checkListId) async {
    final DocumentReference checkListItems = _firebaseFirestore
        .collection('rooms').doc(roomId)
        .collection('check_lists').doc(checkListId)
        .collection('items').doc();
    String newDocId = checkListItems.id;
    try{
      var batch = _firebaseFirestore.batch();
      for (var item in items) {
        batch.set(checkListItems, {
          'id': newDocId,
          'month': item['month'],
          'is_complete': false,
          'content': item['content'],
          'has_comment': false,
          'check_list_id': checkListId,
        });
      }
      await batch.commit();
      debugPrint('チェックリストアイテム作成完了');
      return true;
    } on FirebaseException catch (e) {
      debugPrint('チェックリストアイテム作成エラー: $e');
      return false;
    }
  }

  static Future<bool> updateItem(Item updateItem,  CheckList checkList) async {
    DocumentReference<Map<String, dynamic>> collectionReference = _firebaseFirestore
        .collection('rooms').doc(checkList.roomId)
        .collection('check_lists').doc(checkList.id)
        .collection('items').doc(updateItem.id);
    try {
      await collectionReference.update({
        'has_comment': updateItem.hasComment,
        'is_complete': updateItem.isComplete,
        'completed_time': updateItem.completedTime
      });
      debugPrint('チェックリストアイテム更新完了');
      return true;
    } on FirebaseException catch(e) {
      debugPrint('チェックリストアイテム更新エラー: $e');
      return false;
    }
  }
}