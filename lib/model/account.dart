import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  String id;
  String name;
  String imagePath;
  String userId;
  String selfIntroduction;
  String email;
  Timestamp? createdTime;
  Timestamp? updatedTime;

  Account({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.userId,
    required this.selfIntroduction,
    required this.email,
    this.createdTime,
    this.updatedTime,
  });
}