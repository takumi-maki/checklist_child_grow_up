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

enum CheckListType {
  body,
  hand,
  voice,
  life
}

checkListTypeToInt(CheckListType type) {
  switch (type) {
    case CheckListType.body:
      return 0;
    case CheckListType.hand:
      return 1;
    case CheckListType.voice:
      return 2;
    case CheckListType.life:
      return 3;
    default:
      return 0;
  }
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
  memberList,
  privacyPolicy,
  termsOfService,
  contact,
  deleteRoom
}

