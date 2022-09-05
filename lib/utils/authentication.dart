import 'package:firebase_auth/firebase_auth.dart';

import '../model/account.dart';

class Authentication {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static User? currentFirebaseUser;
  static Account? myAccount;

  static Future<dynamic> signUp({required String email, required String password}) async {
    try {
      UserCredential newAccount = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      print('auth登録完了');
      return newAccount;
    } on FirebaseAuthException catch(e) {
      print('auth登録エラー');
      return false;
    }
  }

  static Future<dynamic> emailSignIn({required String email, required String password}) async {
    try {
      final UserCredential _result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      currentFirebaseUser = _result.user;
      print('authサインイン完了');
      return _result;
    } on FirebaseAuthException catch (e) {
      print('authサインインエラー: $e');
      return false;
    }
  }
}