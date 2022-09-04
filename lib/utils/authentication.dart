import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static User? currentFirebaseUser;

  static Future<dynamic> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      print('auth登録完了');
      return true;
    } on FirebaseAuthException catch(e) {
      print('auth登録エラー');
      return '登録エラーが発生しました';
    }
  }
}