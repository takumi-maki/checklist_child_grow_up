import 'package:checklist_child_grow_up/model/tile.dart';
import 'package:checklist_child_grow_up/view/room/room_delete_alert_dialog.dart';
import 'package:checklist_child_grow_up/view/room/registered_email_addresses_page.dart';
import 'package:flutter/material.dart';

import '../../utils/widget_utils.dart';

class AboutRoomMenusPage extends StatefulWidget {
  final String roomId;
  final String childName;
  const AboutRoomMenusPage({Key? key, required this.roomId, required this.childName}) : super(key: key);

  @override
  State<AboutRoomMenusPage> createState() => _AboutRoomMenusPageState();
}

class _AboutRoomMenusPageState extends State<AboutRoomMenusPage> {
  late List<Tile> aboutRoomMenus;

  @override
  void initState() {
    super.initState();
    aboutRoomMenus = generateAboutRoomMenus();
  }

  List<Tile> generateAboutRoomMenus() {
    return [
      Tile(
        leading: const Icon(Icons.people),
        title: const Text('登録中のメールアドレス一覧'),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) {
          return RegisteredEmailAddressesPage(roomId: widget.roomId);
        }))
      ),
      Tile(
        leading: const Icon(Icons.delete),
        title: const Text('ルーム削除'),
        isErrorText: true,
        onTap: () => handleRoomDeleteOnTap()
      ),
    ];
  }

  void handleRoomDeleteOnTap() {
    showDialog(context: context, barrierDismissible: false, builder: (context) {
      return RoomDeleteAlertDialog(childName: widget.childName, roomId: widget.roomId);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: WidgetUtils.createAppBar(context, 'ルームについて'),
      body: ListView.builder(
          itemCount: aboutRoomMenus.length,
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: aboutRoomMenus[index].leading,
                  title: aboutRoomMenus[index].title,
                  trailing: const Icon(Icons.arrow_forward_ios),
                  iconColor: aboutRoomMenus[index].isErrorText ? Theme.of(context).colorScheme.error : Colors.black87,
                  textColor: aboutRoomMenus[index].isErrorText ? Theme.of(context).colorScheme.error : Colors.black87,
                  onTap: aboutRoomMenus[index].onTap,
                ),
              ),
            );
          }
      ),
    );
  }
}
