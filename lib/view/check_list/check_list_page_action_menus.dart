import 'package:checklist_child_grow_up/view/about/about_app_page.dart';
import 'package:checklist_child_grow_up/view/about/about_check_list_page.dart';
import 'package:checklist_child_grow_up/view/about/about_room_page.dart';
import 'package:flutter/material.dart';

import '../../model/check_list.dart';

class CheckListPageActionMenus extends StatefulWidget {
  final String childName;
  final String roomId;
  const CheckListPageActionMenus({Key? key, required this.childName, required this.roomId}) : super(key: key);

  @override
  State<CheckListPageActionMenus> createState() => _CheckListPageActionMenusState();
}

class _CheckListPageActionMenusState extends State<CheckListPageActionMenus> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: PopupMenuButton<CheckListPopupMenuItem>(
        onSelected: (CheckListPopupMenuItem value) {
          switch(value) {
            case CheckListPopupMenuItem.aboutRoom:
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) {
                        return AboutRoomPage(childName: widget.childName, roomId: widget.roomId);
                      }
                  )
              );
              break;
            case CheckListPopupMenuItem.aboutCheckList:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const AboutCheckListPage();
                  }
                )
              );
              break;
            case CheckListPopupMenuItem.aboutApp:
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return const AboutAppPage();
                  }
              );
              break;
          }
        },
        itemBuilder: (context) => <PopupMenuEntry<CheckListPopupMenuItem>>[
          PopupMenuItem(
              value: CheckListPopupMenuItem.aboutRoom,
              child: Row(
                children: const [
                  Icon(Icons.room_preferences),
                  SizedBox(width: 15.0),
                  Text('ルームについて', style: TextStyle(fontSize: 14)),
                ],
              )
          ),
          const PopupMenuDivider(),
          PopupMenuItem(
              value: CheckListPopupMenuItem.aboutCheckList,
              child: Row(
                children: const [
                  Icon(Icons.checklist),
                  SizedBox(width: 15.0),
                  Text('成長のチェックリストについて', style: TextStyle(fontSize: 14)),
                ],
              )
          ),
          const PopupMenuDivider(),
          PopupMenuItem(
              value: CheckListPopupMenuItem.aboutApp,
              child: Row(
                children: const [
                  Icon(Icons.info),
                  SizedBox(width: 15.0),
                  Text('アプリについて', style: TextStyle(fontSize: 14)),
                ],
              )
          ),
        ],
        offset: const Offset(0.0, 60.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Icon(Icons.menu),
      ),
    );
  }
}
