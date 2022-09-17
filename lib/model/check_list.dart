import 'package:cloud_firestore/cloud_firestore.dart';

class CheckList {
  String id;
  String roomId;
  int type;

  CheckList({
    required this.id,
    required this.roomId,
    required this.type,
  });
}

class Item {
  String id;
  int month;
  bool isComplete;
  String content;
  String checkListId;
  bool hasComment;
  Timestamp? completedTime;

  Item({
    required this.id,
    required this.month,
    required this.isComplete,
    required this.content,
    required this.checkListId,
    required this.hasComment,
    this.completedTime,
  });
}

enum CheckListPopupMenuItem {
  memberList
}

