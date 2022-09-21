import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_sns_app/model/account.dart';
import 'package:demo_sns_app/utils/authentication.dart';
import 'package:flutter/material.dart';

class UserFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference users = _firestoreInstance.collection('users');

  static Future<dynamic> setUser(Account newAccount) async {
    try {
      await users.doc(newAccount.id).set({
        'name': newAccount.name,
        'created_time': newAccount.createdTime,
      });
      debugPrint('新規ユーザー作成完了');
      return true;
    } on FirebaseException catch (e) {
      debugPrint('新規ユーザー作成エラー: $e');
      return false;
    }
  }

  static Future<dynamic> getUser(String uid) async {
    try {
      DocumentSnapshot documentSnapshot = await users.doc(uid).get();
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      Account myAccount = Account(
        id: uid,
        name: data['name'],
        createdTime: data['created_time'],
      );
      Authentication.myAccount = myAccount;
      debugPrint('ユーザー取得完了');
      return true;
    } on FirebaseException catch (e) {
      debugPrint('ユーザー取得エラー: $e');
      return false;
    }
  }
  static Future<bool> updateUser(Account updateAccount) async {
    try {
      await users.doc(updateAccount.id).update({
        'name': updateAccount.name,
        'updated_time': Timestamp.now(),
      });
      debugPrint('ユーザー情報の更新完了');
      return true;
    } on FirebaseException catch (e) {
      debugPrint('ユーザー情報の更新エラー : $e');
      return false;
    }
  }

  // タイムラインに表示するusersの情報を取得 型はmap 引数はaccountのid等
  static Future<Map<String, Account>?> getPostUserMap(List<String> accountIds) async {
    Map<String, Account> map = {};
    try {
      await Future.forEach(accountIds, (String accountId) async {
        var doc = await users.doc(accountId).get();
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Account postAccount = Account(
          id: accountId,
          name: data['name'],
          createdTime: data['created_time'],
        );
        map[accountId] = postAccount;
      });
      debugPrint('投稿ユーザーの情報取得完了');
      return map;
    } on FirebaseException catch(e) {
      debugPrint('投稿ユーザーの情報取得エラー: $e');
      return null;
    }
  }
}