import 'package:checklist_child_grow_up/utils/function_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/model/room.dart';
import 'package:checklist_child_grow_up/utils/firestore/check_lists.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../model/check_list.dart';

class RoomFirestore {
  static final _firebaseFireStore = FirebaseFirestore.instance;
  static final CollectionReference rooms = _firebaseFireStore.collection(('rooms'));
  static const uuid = Uuid();

  static Future<bool> setNewRoom(Room newRoom) async {
    try {
      final batch = _firebaseFireStore.batch();
      DocumentReference newRoomsDoc = rooms.doc();
      batch.set(newRoomsDoc, {
        'id': newRoomsDoc.id,
        'child_name': newRoom.childName,
        'joined_accounts': newRoom.joinedAccounts,
        'created_time': newRoom.createdTime,
      });
      List<dynamic> checkListAllItem = await FunctionUtils.getCheckListItems();
      CheckList.tabBarList.asMap().forEach((index, tabBar) async {
        List typeItems = checkListAllItem[index];
        List newItems = [];
        for (var item in typeItems) {
          newItems.add({
            'id': uuid.v4(),
            'month': item['month'],
            'content': item['content'],
            'has_comment': false,
            'is_complete': false,
          });
        }
        await CheckListFirestore.setNewCheckLists(batch, tabBar['type'], newRoomsDoc.id, newItems);
      });
      await batch.commit();
      debugPrint('ルーム作成完了');
      return true;
    } on FirebaseException catch(e) {
      debugPrint('ルーム作成エラー: $e');
      return false;
    }
  }
  static Future<bool> updateRoom(Room updateRoom) async {
    try {
      await rooms.doc(updateRoom.id).set({
        'id': updateRoom.id,
        'child_name': updateRoom.childName,
        'joined_accounts': updateRoom.joinedAccounts,
        'created_time': updateRoom.createdTime,
      });
      debugPrint('ルーム情報更新完了');
      return true;
    } on FirebaseException catch(e) {
      debugPrint('ルーム情報更新エラー: $e');
      return false;
    }
  }
  static Future<bool> deleteRoom(String roomId) async {
    try {
      final batch = _firebaseFireStore.batch();
      final DocumentReference roomsDocRef = rooms.doc(roomId);
      batch.delete(roomsDocRef);
      await CheckListFirestore.deleteCheckLists(batch, roomsDocRef);
      await batch.commit();
      debugPrint('ルーム削除完了');
      return true;
    } on FirebaseException catch (e) {
      debugPrint('ルーム削除エラー: $e');
      return false;
    }
  }
}