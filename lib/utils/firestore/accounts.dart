import 'package:checklist_child_grow_up/model/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AccountFirestore {
  static final CollectionReference accounts = FirebaseFirestore.instance.collection('accounts');

  static Future<bool> setNewAccount(Account newAccount) async {
    try {
      await accounts.doc(newAccount.id).set({
        'id': newAccount.id,
        'name': newAccount.name,
        'email': newAccount.email,
        'image_path': newAccount.imagePath
      });
      debugPrint('アカウント作成完了');
      return true;
    } on FirebaseException catch (e) {
      debugPrint('アカウント作成エラー: $e');
      return false;
    }
  }

  static Future<Account?> getMyAccount(String accountId) async {
    Account? account;
    try {
      DocumentSnapshot documentReference = await accounts.doc(accountId).get();
      Map<String, dynamic> data = documentReference.data() as Map<String, dynamic>;
      account = Account(
        id: data['id'],
        name: data['name'],
        email: data['email'],
        imagePath: data['image_path']
      );
      debugPrint('アカウント情報取得成功');
      return account;
    } on FirebaseException catch (e) {
      debugPrint('アカウント情報取得失敗: $e');
      return null;
    }
  }

  static Future<bool> updateAccount(Account updatedAccount) async {
    try {
      await accounts.doc(updatedAccount.id).set({
        'id': updatedAccount.id,
        'name': updatedAccount.name,
        'email': updatedAccount.email,
        'image_path': updatedAccount.imagePath,
      });
      debugPrint('アカウント情報更新完了');
      return true;
    } on FirebaseException catch(e) {
      debugPrint('アカウント情報更新エラー: $e');
      return false;
    }
  }

  static Future<bool> deleteAccount(String accountId) async {
    try {
      await accounts.doc(accountId).delete();
      debugPrint('アカウント削除成功');
      return true;
    } on FirebaseException catch (e) {
      debugPrint('アカウント削除失敗: $e');
      return false;
    }
  }
}