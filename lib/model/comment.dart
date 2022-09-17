import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String text;
  String itemId;
  String postAccountId;
  Timestamp createdTime;

  Comment({
    required this.text,
    required this.itemId,
    required this.postAccountId,
    required this.createdTime,
  });
}