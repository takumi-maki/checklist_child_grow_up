import 'package:flutter/material.dart';

import '../view/room/room_list_page.dart';
import 'firestore/rooms.dart';
import 'loading/loading_elevated_button.dart';

class RoomDeleteAlertDialog extends StatefulWidget {
  final String childName;
  final String roomId;
  const RoomDeleteAlertDialog({Key? key, required this.childName, required this.roomId}) : super(key: key);

  @override
  State<RoomDeleteAlertDialog> createState() => _RoomDeleteAlertDialogState();
}

class _RoomDeleteAlertDialogState extends State<RoomDeleteAlertDialog> {
  @override
  Widget build(BuildContext context) {
      return AlertDialog(
          title: const Text('ルームの削除'),
          content: Text('本当に${widget.childName}のルームを削除してもいいですか?'),
          actions: [
            OutlinedButton(onPressed: () {
              Navigator.of(context).pop();
            },
              style: OutlinedButton.styleFrom(primary: Colors.grey),
              child: Text('キャンセル'),
            ),
            LoadingElevatedButton(
                onPressed: () async {
                  var result = await RoomFirestore.deleteRoom(widget.roomId);
                  if(result) {
                    if(!mounted) return;
                    while(Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RoomListPage()));
                  }
                },
                child: Text('削除')
            )
          ],
        );
    }
}
