import '../../utils/loading/change_button.dart';
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
        title: const Text('ルームの削除'),
        content: Text('本当に${widget.childName}のルームを削除してもよろしいですか?'),
        actions: [
          Column(
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  primary: Colors.black87,
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
                      WidgetUtils.errorSnackBar(context, 'ルーム削除に失敗しました');
                      ChangeButton.showErrorFor4Seconds(btnController);
                      if(!mounted) return;
                      return Navigator.pop(context);
                    }
                    await ChangeButton.showSuccessFor1Seconds(btnController);
                    if(!mounted) return;
                    while(Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                    if(!mounted) return;
                    Navigator.pushReplacement(
                      context, MaterialPageRoute(
                        builder: (context) => const RoomListPage()
                      )
                    );
                  },
                  color: Theme.of(context).errorColor,
                  child: const Text('ルーム削除')
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ],
      );
    }
}
