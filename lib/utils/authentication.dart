import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/account.dart';

class Authentication {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static User? currentFirebaseUser;
  static Account? myAccount;

  static Future<dynamic> signUp({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch(e) {
      if (e.code == 'email-already-in-use') {
        return '指定したメールアドレスは登録済みです';
      } else if (e.code == 'operation-not-allowed') {
        return '指定したメールアドレス・パスワードは現在使用できません';
      } else {
        return 'アカウントの作成に失敗しました';
      }
    }
  }

  static Future<dynamic> emailSignIn({required String email, required String password}) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      currentFirebaseUser = userCredential.user;
      debugPrint('authサインイン完了');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'このアカウントは存在しません';
      } else if (e.code == 'wrong-password') {
        return 'パスワードが正しくありません';
      } else {
        return 'ログインに失敗しました';
      }
      debugPrint('authサインインエラー: $e');
      return false;
    }
  }

  static Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  static Future<void> deleteAuth() async {
    await currentFirebaseUser!.delete();
  }
}