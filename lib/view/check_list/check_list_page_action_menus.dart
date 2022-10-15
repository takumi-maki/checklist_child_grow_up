import 'package:checklist_child_grow_up/utils/function_utils.dart';
import 'package:flutter/material.dart';

import '../../model/check_list.dart';
import '../room/room_delete_alert_dialog.dart';
import '../room/room_member_email_list_page.dart';

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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: PopupMenuButton<CheckListPopupMenuItem>(
        onSelected: (CheckListPopupMenuItem value) {
          switch(value) {
            case CheckListPopupMenuItem.memberList:
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) {
                        return RoomMemberEmailListPage(roomId: widget.roomId);
                      }
                  )
              );
              break;
            case CheckListPopupMenuItem.contact:
              FunctionUtils.contactFormLaunchUrl();
              break;
            case CheckListPopupMenuItem.deleteRoom:
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return RoomDeleteAlertDialog(childName: widget.childName, roomId: widget.roomId);
                  }
              );
              break;
          }
        },
        itemBuilder: (context) => <PopupMenuEntry<CheckListPopupMenuItem>>[
          PopupMenuItem(
              value: CheckListPopupMenuItem.memberList,
              child: Row(
                children: const [
                  Icon(Icons.people),
                  SizedBox(width: 15.0),
                  Text('登録中メールアドレス一覧'),
                ],
              )
          ),
          const PopupMenuDivider(),
          PopupMenuItem(
              value: CheckListPopupMenuItem.contact,
              child: Row(
                children: const [
                  Icon(Icons.contact_mail),
                  SizedBox(width: 15.0),
                  Text('お問い合せ'),
                ],
              )
          ),
          const PopupMenuDivider(),
          PopupMenuItem(
              value: CheckListPopupMenuItem.deleteRoom,
              child: Row(
                children: const [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 15.0),
                  Text('ルーム削除', style: TextStyle(color: Colors.red)),
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
