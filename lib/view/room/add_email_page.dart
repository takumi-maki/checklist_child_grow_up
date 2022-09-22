import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_sns_app/utils/firestore/rooms.dart';
import 'package:demo_sns_app/utils/loading_dialog.dart';
import 'package:demo_sns_app/utils/widget_utils.dart';
import 'package:flutter/material.dart';

import '../../model/room.dart';
import '../../utils/loading_elevated_button.dart';

class AddEmailPage extends StatefulWidget {
  final String roomId;
  const AddEmailPage({Key? key, required this.roomId}) : super(key: key);

  @override
  State<AddEmailPage> createState() => _RoomAddEmailPageState();
}

class _RoomAddEmailPageState extends State<AddEmailPage> {
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final emailRegExp = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('メールアドレスの追加'),
      body: SizedBox(
        width: double.infinity,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 30.0),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: emailController,
                  validator: (value) {
                    bool emailRegValidationResult = value!.contains(emailRegExp);
                    return emailRegValidationResult ? null : '無効なメールアドレスです';
                  },
                  decoration: const InputDecoration(
                    hintText: 'メールアドレス'
                  ),
                ),
              ),
              SizedBox(height: 30),
              LoadingElevatedButton(
                onPressed: () async {
                  if(!formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('有効なメールアドレスを入力して下さい'))
                    );
                    return;
                  }
                  await showLoadingDialog(context);
                  if(emailController.text.isNotEmpty) {
                    DocumentSnapshot documentSnapshot = await RoomFirestore.rooms.doc(widget.roomId).get();
                    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                    List<dynamic> newJoinedAccounts = data['joined_accounts'];
                    newJoinedAccounts.add(emailController.text);
                    Room updateRoom = Room(
                        id: widget.roomId,
                        childName: data['child_name'],
                        joinedAccounts: newJoinedAccounts,
                        createdTime: data['created_time']
                    );
                    var result = await RoomFirestore.updateRoom(updateRoom);
                    if(result) {
                      hideLoadingDialog(context);
                      if(!mounted) return;
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('追加')),
            ],
          ),
        )
        ,
      ),
    );
  }
}
