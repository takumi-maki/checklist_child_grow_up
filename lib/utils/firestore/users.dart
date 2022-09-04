import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_sns_app/model/account.dart';

class UserFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference users = _firestoreInstance.collection('users');

  static Future<dynamic> setUser(Account newAccount) async {
    try {
      await users.doc(newAccount.id).set({
        'name': newAccount.name,
        'userId': newAccount.userId,
        'self_introduction': newAccount.selfIntroduction,
        'image_path': newAccount.imagePath,
        'created_time': Timestamp.now(),
        'updated_time': Timestamp.now(),
      });
      print('新規ユーザー作成完了');
      return true;
    } on FirebaseException catch (e) {
      print('新規ユーザー作成エラー');
      return false;
    }
  }
}