import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  String id;
  String childName;
  List<dynamic> joinedAccounts;
  Timestamp createdTime;

  Room({
    required this.id,
    required this.childName,
    required this.joinedAccounts,
    required this.createdTime
  });
}

enum RoomListPopupMenuItem {
  signOut,
}