import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_sns_app/model/room.dart';
import 'package:demo_sns_app/utils/firestore/check_lists.dart';
import 'package:flutter/material.dart';

class RoomFirestore {
  static final _firebaseFireStore = FirebaseFirestore.instance;
  static final CollectionReference rooms = _firebaseFireStore.collection(('rooms'));

  static Future<String?> setRoom(Room newRoom) async {
    try {
      DocumentReference newDoc = rooms.doc();
      await newDoc.set({
        'id': newDoc.id,
        'child_name': newRoom.childName,
        'joined_accounts': newRoom.joinedAccounts,
        'created_time': newRoom.createdTime,
      });
      debugPrint('ルーム作成完了');
      return newDoc.id;
    } on FirebaseException catch(e) {
      debugPrint('ルーム作成エラー: $e');
      return null;
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
      await rooms.doc(roomId).delete();
      await CheckListFirestore.deleteChecklists(roomId);
      debugPrint('ルーム削除完了');
      return true;
    } on FirebaseException catch(e) {
      debugPrint('ルーム削除エラー: $e');
      return false;
    }
  }
}