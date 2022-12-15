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

  static final List<Map> tabBarList = [
    {
      'type': CheckListType.body,
      'text': 'からだ',
      'imagePath': 'assets/images/hiyoko_run.png'
    },
    {
      'type': CheckListType.hand,
      'text': '手のうごき',
      'imagePath': 'assets/images/hiyoko_crayon.png'
    },
    {
      'type': CheckListType.voice,
      'text': 'ことば',
      'imagePath': 'assets/images/hiyoko_voice.png'
    },
    {
      'type': CheckListType.life,
      'text': 'せいかつ',
      'imagePath': 'assets/images/hiyoko_heart.png'
    },
  ];
}

enum CheckListType {
  body,
  hand,
  voice,
  life
}


class CheckListProgress {
  CheckListType type;
  int totalItemsCount;
  int isAchievedItemsCount;

  CheckListProgress({
    required this.type,
    required this.totalItemsCount,
    required this.isAchievedItemsCount
  });
}

int checkListTypeToInt(CheckListType type) {
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

CheckListType intToCheckListType(int value) {
  switch (value) {
    case 0:
      return CheckListType.body;
    case 1:
      return CheckListType.hand;
    case 2:
      return CheckListType.voice;
    case 3:
      return CheckListType.life;
    default:
      return CheckListType.body;
  }
}


class Item {
  String id;
  int month;
  bool isAchieved;
  String content;
  Timestamp? achievedTime;

  Item({
    required this.id,
    required this.month,
    required this.isAchieved,
    required this.content,
    this.achievedTime,
  });
}

enum CheckListPopupMenuItem {
  aboutCheckList,
  aboutRoom,
  aboutAccount,
  aboutApp,
}

