import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationFirestore {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static User? currentFirebaseUser;

  static Future<dynamic> signUp({required name, required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await _firebaseAuth.currentUser!.updateDisplayName(name);
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

  static Future<User?> checkCurrentFirebaseUser() async {
    // 擬似的に通信中を表現するため、3秒遅らす
    await Future.delayed(const Duration(seconds: 3));
    AuthenticationFirestore.currentFirebaseUser = FirebaseAuth.instance.currentUser;
    if(AuthenticationFirestore.currentFirebaseUser == null) {
      return null;
    }
    return AuthenticationFirestore.currentFirebaseUser;
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
    }
  }

  static Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  static Future<void> deleteAuth() async {
    await currentFirebaseUser!.delete();
  }

  static Future<String> sendPasswordRestEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      debugPrint('パスワード再設定メール完了');
      return 'success';
    } on FirebaseAuthException catch(e) {
      debugPrint('パスワード再設定メールエラー');
      if (e.code == 'user-not-found') {
        return '指定したメールアドレスは登録されていません';
      } else {
        return 'パスワードリセットのメール送信に失敗しました';
      }
    }
  }
}