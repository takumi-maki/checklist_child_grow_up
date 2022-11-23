import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationFirestore {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static User? currentFirebaseUser;

  static Future<dynamic> signUp({required String name, required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await _firebaseAuth.currentUser!.updateDisplayName(name);
      debugPrint('Authentication ユーザ作成完了');
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
    try {
      // 擬似的に通信中を表現するため、3秒遅らす
      await Future.delayed(const Duration(seconds: 3));
      AuthenticationFirestore.currentFirebaseUser = FirebaseAuth.instance.currentUser;
      debugPrint('ログインチェック完了');
      return AuthenticationFirestore.currentFirebaseUser;
    } on FirebaseAuthException catch(e) {
      debugPrint('ログインチェックエラー :$e');
      return null;
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
    }
  }

  static Future<void> signOut() async {
    await _firebaseAuth.signOut();
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

  static Future<dynamic> reAuthenticate(User user, String password) async {
    final credential = EmailAuthProvider.credential(email: user.email!, password: password);
    try {
      UserCredential userCredential = await user.reauthenticateWithCredential(credential);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      late String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'このアカウントは存在しません';
          break;
        case 'wrong-password':
          errorMessage = 'パスワードが正しくありません';
          break;
        default:
          errorMessage = 'アカウント削除に失敗しました';
          break;
      }
      return errorMessage;
    }
  }

  static Future<bool> deleteAuth(User user) async {
    try {
      await user.delete();
      debugPrint('Auth削除成功');
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint('Auth削除失敗: $e');
      return false;
    }
  }
}