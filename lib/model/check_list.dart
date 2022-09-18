import 'package:cloud_firestore/cloud_firestore.dart';

class CheckList {
  String id;
  String roomId;
  int type;
  List<Item> items;

  CheckList({
    required this.id,
    required this.roomId,
    required this.type,
    required this.items,
  });
}

class Item {
  String id;
  int month;
  bool isComplete;
  String content;
  bool hasComment;
  Timestamp? completedTime;

  Item({
    required this.id,
    required this.month,
    required this.isComplete,
    required this.content,
    required this.hasComment,
    this.completedTime,
  });
}

enum CheckListPopupMenuItem {
  memberList
}

