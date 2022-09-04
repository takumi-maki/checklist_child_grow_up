import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static User? currentFirebaseUser;

  static Future<bool> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      print('auth登録完了');
      return true;
    } on FirebaseAuthException catch(e) {
      print('auth登録エラー');
      return false;
    }
  }

  static Future<bool> emailSignIn({required String email, required String password}) async {
    try {
      final UserCredential _result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      currentFirebaseUser = _result.user;
      print('authサインイン完了');
      return true;
    } on FirebaseAuthException catch (e) {
      print('authサインインエラー: $e');
      return false;
    }
  }
}