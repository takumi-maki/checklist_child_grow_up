import 'package:checklist_child_grow_up/model/tile.dart';
import 'package:checklist_child_grow_up/view/room/room_delete_alert_dialog.dart';
import 'package:checklist_child_grow_up/view/room/registered_email_addresses_page.dart';
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
  late List<Tile> aboutRoomContentList;

  @override
  void initState() {
    super.initState();
    aboutRoomContentList = [
      Tile(
          leading: const Icon(Icons.people),
          title: const Text('登録中のメールアドレス一覧'),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) {
                      return RegisteredEmailAddressesPage(roomId: widget.roomId);
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
            showRoomDeleteAlertDialog();
          }
      ),
    ];
  }

  void showRoomDeleteAlertDialog() {
    showDialog(context: context, barrierDismissible: false, builder: (context) {
      return RoomDeleteAlertDialog(childName: widget.childName, roomId: widget.roomId);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: WidgetUtils.createAppBar(context, 'ルームについて'),
      body: ListView.builder(
          itemCount: aboutRoomContentList.length,
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: aboutRoomContentList[index].leading,
                  title: aboutRoomContentList[index].title,
                  trailing: const Icon(Icons.arrow_forward_ios),
                  iconColor: aboutRoomContentList[index].id == 'deleteRoom' ? Colors.red : Colors.black87,
                  textColor: aboutRoomContentList[index].id == 'deleteRoom' ? Colors.red : Colors.black87,
                  onTap: aboutRoomContentList[index].onTap,
                ),
              ),
            );
          }
      ),
    );
  }
}
