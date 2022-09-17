import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_sns_app/model/check_list.dart';
import 'package:demo_sns_app/utils/firestore/rooms.dart';
import 'package:flutter/material.dart';


class CheckListFirestore {
  static final _firebaseFirestore = FirebaseFirestore.instance;

  static Future<String?> setCheckList(int type, String roomId) async {
    final DocumentReference roomCheckLists = _firebaseFirestore
        .collection('rooms').doc(roomId)
        .collection('check_lists').doc();
    String newDocId = roomCheckLists.id;
    try {
      await roomCheckLists.set({
        'id': newDocId,
        'type': type,
        'room_id': roomId,
      });
      return newDocId;
    } on FirebaseException catch(e){
      debugPrint('チェックリスト作成エラー : $e');
      return null;
    }
  }
}

