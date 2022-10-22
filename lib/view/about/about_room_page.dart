import 'package:checklist_child_grow_up/model/tile.dart';
import 'package:checklist_child_grow_up/view/room/room_delete_alert_dialog.dart';
import 'package:checklist_child_grow_up/view/room/room_member_email_list_page.dart';
import 'package:flutter/material.dart';

import '../../utils/widget_utils.dart';

class AboutRoomPage extends StatefulWidget {
  final String roomId;
  final String childName;
  const AboutRoomPage({Key? key, required this.roomId, required this.childName}) : super(key: key);

  @override
  State<AboutRoomPage> createState() => _AboutRoomPageState();
}

class _AboutRoomPageState extends State<AboutRoomPage> {
  @override

  Widget build(BuildContext context) {
    List<Tile> aboutAppContentList = [
      Tile(
        leading: const Icon(Icons.people),
        title: const Text('登録中のメールアドレス一覧'),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) {
                    return RoomMemberEmailListPage(roomId: widget.roomId);
                  }
              )
          );
        }
      ),
      Tile(
        id: 'deleteRoom',
        leading: const Icon(Icons.delete),
        title: const Text('ルーム削除'),
        onTap: () {
          showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return RoomDeleteAlertDialog(childName: widget.childName, roomId: widget.roomId);
            }
          );
        }
      ),
    ];
    return Scaffold(
      appBar: WidgetUtils.createAppBar('ルームについて'),
      body: ListView.builder(
          itemCount: aboutAppContentList.length,
          itemBuilder: (context, index) {
            return Card(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: aboutAppContentList[index].leading,
                  title: aboutAppContentList[index].title,
                  trailing: const Icon(Icons.arrow_forward_ios),
                  iconColor: aboutAppContentList[index].id == 'deleteRoom' ? Colors.red : Colors.black87,
                  textColor: aboutAppContentList[index].id == 'deleteRoom' ? Colors.red : Colors.black87,
                  onTap: aboutAppContentList[index].onTap,
                ),
              ),
            );
          }
      ),
    );
  }
}
