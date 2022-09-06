import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id;
  String content;
  String postAccountId;
  Timestamp? createdTime;

  Post({
    required this.id,
    required this.content,
    required this.postAccountId,
    required this.createdTime,
  });
}