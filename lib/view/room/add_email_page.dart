import '../../utils/loading/change_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/utils/firestore/rooms.dart';
import 'package:checklist_child_grow_up/utils/validator.dart';
import 'package:checklist_child_grow_up/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../model/room.dart';
import '../../utils/loading/loading_button.dart';

class AddEmailPage extends StatefulWidget {
  final String roomId;
  const AddEmailPage({Key? key, required this.roomId}) : super(key: key);

  @override
  State<AddEmailPage> createState() => _RoomAddEmailPageState();
}

class _RoomAddEmailPageState extends State<AddEmailPage> {
  TextEditingController emailController = TextEditingController();
  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar(context, 'メールアドレス追加'),
      body: SizedBox(
        width: double.infinity,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 30.0),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: emailController,
                  validator: (value) {
                    return Validator.getEmailRegValidatorMessage(value);
                  },
                  decoration: const InputDecoration(
                    labelText: 'メールアドレス',
                    labelStyle: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              LoadingButton(
                btnController: btnController,
                onPressed: () async {
                  if(!formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      WidgetUtils.errorSnackBar('正しく入力されていない項目があります')
                    );
                    return ChangeButton.showErrorFor4Seconds(btnController);
                  }
                  if(emailController.text.isNotEmpty) {
                    DocumentSnapshot documentSnapshot = await RoomFirestore.rooms.doc(widget.roomId).get();
                    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                    List<dynamic> newJoinedAccounts = data['joined_accounts'];
                    if(newJoinedAccounts.contains(emailController.text)) {
                      if(!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        WidgetUtils.errorSnackBar('既に登録済みのメールアドレスです')
                      );
                      return ChangeButton.showErrorFor4Seconds(btnController);
                    }
                    newJoinedAccounts.add(emailController.text);
                    Room updateRoom = Room(
                        id: widget.roomId,
                        childName: data['child_name'],
                        joinedAccounts: newJoinedAccounts,
                        createdTime: data['created_time']
                    );
                    var result = await RoomFirestore.updateRoom(updateRoom);
                    if(!result) {
                      if(!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                          WidgetUtils.errorSnackBar('メールアドレスの追加に失敗しました')
                      );
                      return ChangeButton.showErrorFor4Seconds(btnController);
                    }
                    await ChangeButton.showSuccessFor1Seconds(btnController);
                    if(!mounted) return;
                    Navigator.pop(context);
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
