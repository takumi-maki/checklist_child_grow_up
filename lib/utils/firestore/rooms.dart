import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_sns_app/model/room.dart';
import 'package:flutter/material.dart';

class RoomFirestore {
  static final _firebaseFireStore = FirebaseFirestore.instance;
  static final CollectionReference rooms = _firebaseFireStore.collection(('rooms'));

  static Future<bool> addRoom(Room newRoom) async {
    try {
      await rooms.add({
        'child_name': newRoom.childName,
        'joined_accounts': newRoom.joinedAccounts,
        'created_time': newRoom.createdTime,
      });
      debugPrint('ルーム作成完了');
      return true;
    } on FirebaseException catch(e) {
      debugPrint('ルーム作成エラー: $e');
      return false;
    }
  }
}