import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/model/room.dart';
import 'package:checklist_child_grow_up/utils/firestore/check_lists.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../model/check_list.dart';
import '../function_utils.dart';

class RoomFirestore {
  static final _firebaseFireStore = FirebaseFirestore.instance;
  static final CollectionReference rooms = _firebaseFireStore.collection(('rooms'));
  static const uuid = Uuid();

  static Future<bool> setNewRoom(Room newRoom) async {
    try {
      final batch = _firebaseFireStore.batch();
      DocumentReference newRoomsDoc = rooms.doc(newRoom.id);
      batch.set(newRoomsDoc, {
        'id': newRoom.id,
        'child_name': newRoom.childName,
        'birthdate': newRoom.birthdate,
        'registered_email_addresses': newRoom.registeredEmailAddresses,
        'image_path': newRoom.imagePath
      });
      List<dynamic> checkListAllItems = await FunctionUtils.getCheckListItems();
      CheckList.tabBarList.asMap().forEach((index, tabBar) async {
        List typeItems = checkListAllItems[index];
        List newItems = [];
        for (var item in typeItems) {
          newItems.add({
            'id': uuid.v4(),
            'month': item['month'],
            'content': item['content'],
            'is_achieved': false,
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
        'birthdate': updateRoom.birthdate,
        'registered_email_addresses': updateRoom.registeredEmailAddresses,
        'image_path': updateRoom.imagePath,
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