import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String id;
  String? text;
  String? imagePath;
  String itemId;
  String postedAccountId;
  String? postedAccountName;
  List<dynamic> readAccountIds;
  Timestamp createdTime;

  Comment({
    required this.id,
    this.text,
    this.imagePath,
    required this.itemId,
    required this.postedAccountId,
    this.postedAccountName,
    required this.readAccountIds,
    required this.createdTime,
  });
}