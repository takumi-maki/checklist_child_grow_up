import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/account.dart';

class Authentication {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static User? currentFirebaseUser;
  static Account? myAccount;

  static Future<dynamic> signUp({required String email, required String password}) async {
    try {
      UserCredential newAccount = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      debugPrint('auth登録完了');
      return newAccount;
    } on FirebaseAuthException catch(e) {
      debugPrint('auth登録エラー: $e');
      return false;
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