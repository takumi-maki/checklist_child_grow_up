import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String? text;
  String? imagePath;
  String itemId;
  String postAccountId;
  String? postAccountName;
  Timestamp createdTime;

  Comment({
    this.text,
    this.imagePath,
    required this.itemId,
    required this.postAccountId,
    this.postAccountName,
    required this.createdTime,
  });
}