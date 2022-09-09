import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  String childName;
  List<String?> joinedAccounts;
  Timestamp createdTime;

  Room({
    required this.childName,
    required this.joinedAccounts,
    required this.createdTime
  });
}