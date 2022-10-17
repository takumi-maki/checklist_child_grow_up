import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../utils/widget_utils.dart';
import 'room_list_page.dart';
import '../../utils/firestore/rooms.dart';
import '../../utils/loading/loading_button.dart';

class RoomDeleteAlertDialog extends StatefulWidget {
  final String childName;
  final String roomId;
  const RoomDeleteAlertDialog({Key? key, required this.childName, required this.roomId}) : super(key: key);

  @override
  State<RoomDeleteAlertDialog> createState() => _RoomDeleteAlertDialogState();
}

class _RoomDeleteAlertDialogState extends State<RoomDeleteAlertDialog> {
  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('ルーム削除'),
        content: Text('本当に ${widget.childName} のルームを削除してもいいですか?'),
        actions: [
          Column(
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  primary: Colors.grey,
                  minimumSize: const Size(150, 36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)
                  )
                ),
                child: const Text('キャンセル'),
              ),

              const SizedBox(height: 6.0),
              LoadingButton(
                  btnController: btnController,
                  onPressed: () async {
                    var result = await RoomFirestore.deleteRoom(widget.roomId);
                    if(!result) {
                      btnController.error();
                      if(!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                      WidgetUtils.errorSnackBar('ルームの削除に失敗しました')
                      );
                      Navigator.of(context).pop();
                      await Future.delayed(const Duration(milliseconds: 4000));
                      btnController.reset();
                      return;
                    }
                    if(!mounted) return;
                    while(Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                    Navigator.pushReplacement(
                      context, MaterialPageRoute(
                        builder: (context) => const RoomListPage()
                      )
                    );
                  },
                  color: Colors.red,
                  child: const Text('削除')
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ],
      );
    }
}
