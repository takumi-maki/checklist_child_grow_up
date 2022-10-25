import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/model/account.dart';
import 'package:checklist_child_grow_up/utils/firestore/authentications.dart';
import 'package:flutter/material.dart';

class UserFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference users = _firestoreInstance.collection('users');

  static Future<dynamic> setUser(Account newAccount) async {
    try {
      await users.doc(newAccount.id).set({
        'name': newAccount.name,
      });
      debugPrint('新規ユーザー作成完了');
      return true;
    } on FirebaseException catch (e) {
      debugPrint('新規ユーザー作成エラー: $e');
      return false;
    }
  }

  static Future<Account?> getAccount(String uid) async {
    try {
      DocumentSnapshot documentSnapshot = await users.doc(uid).get();
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      Account account = Account(
        id: uid,
        name: data['name'],
      );
      debugPrint('account取得完了');
      return account;
    } on FirebaseException catch (e) {
      debugPrint('account取得エラー: $e');
      return null;
    }
  }

  static Future<bool> storeMyAccount(String uid) async {
    try {
      DocumentSnapshot documentSnapshot = await users.doc(uid).get();
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      Account myAccount = Account(
        id: uid,
        name: data['name'],
      );
      AuthenticationFirestore.myAccount = myAccount;
      debugPrint('myAccountに格納完了');
      return true;
    } on FirebaseException catch (e) {
      debugPrint('myAccountに格納エラー: $e');
      return false;
    }
  }

  // コメント欄に表示するusersの情報を取得 型はmap 引数はaccountのid等
  static Future<Map<String, Account>?> getCommentUserMap(List<String> accountIds) async {
    Map<String, Account> map = {};
    try {
      await Future.forEach(accountIds, (String accountId) async {
        var doc = await users.doc(accountId).get();
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Account postAccount = Account(
          id: accountId,
          name: data['name'],
        );
        map[accountId] = postAccount;
      });
      debugPrint('コメントしたユーザーの情報取得完了');
      return map;
    } on FirebaseException catch(e) {
      debugPrint('コメントしたユーザーの情報取得エラー: $e');
      return null;
    }
  }
}