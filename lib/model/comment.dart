import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String text;
  String itemId;
  String postAccountId;
  String postAccountName;
  Timestamp createdTime;

  Comment({
    required this.text,
    required this.itemId,
    required this.postAccountId,
    required this.postAccountName,
    required this.createdTime,
  });
}