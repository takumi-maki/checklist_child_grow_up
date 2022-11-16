import 'package:checklist_child_grow_up/model/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AccountFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static CollectionReference accounts = _firestoreInstance.collection('accounts');

  static Future<bool> setAccount(Account newAccount) async {
    try {
      await accounts.doc(newAccount.id).set({
        'id': newAccount.id,
        'name': newAccount.name,
        'email': newAccount.email
      });
      debugPrint('アカウント作成完了');
      return true;
    } on FirebaseException catch (e) {
      debugPrint('アカウント作成エラー: $e');
      return false;
    }
  }
}