import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_sns_app/utils/authentication.dart';
import 'package:demo_sns_app/utils/firestore/check_lists.dart';
import 'package:demo_sns_app/utils/firestore/rooms.dart';
import 'package:demo_sns_app/utils/function_utils.dart';
import 'package:demo_sns_app/utils/validator.dart';
import 'package:demo_sns_app/utils/widget_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../model/room.dart';
import '../../utils/loading/loading_elevated_button.dart';

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({Key? key}) : super(key: key);

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  User user = Authentication.currentFirebaseUser!;
  TextEditingController childNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var uuid = const Uuid();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('ルーム作成'),
      body: SizedBox(
        width: double.infinity,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 30),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: childNameController,
                  validator: (value) {
                    return Validator.getRequiredValidatorMessage(value);
                  },
                  decoration: const InputDecoration(
                    hintText: 'お子さんのお名前'
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: partnerEmailController,
                  validator: (value) {
                    if(partnerEmailController.text.isEmpty) return null;
                    return Validator.getEmailRegValidatorMessage(value);
                  },
                  decoration: const InputDecoration(
                      hintText: 'パートナーのメールアドレス'
                  ),
                ),
              ),
              const SizedBox(height: 50),
              LoadingElevatedButton(
                onPressed: () async {
                  if(!formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      WidgetUtils.errorSnackBar('ルームの作成に失敗しました')
                    );
                    return;
                  }
                  List<dynamic> joinedAccounts =  partnerEmailController.text.isEmpty
                      ? [user.email]
                      : [user.email, partnerEmailController.text];
                  Room newRoom = Room(
                    id: '',
                    childName: childNameController.text,
                    joinedAccounts: joinedAccounts,
                    createdTime: Timestamp.now(),
                  );
                  var roomId = await RoomFirestore.setRoom(newRoom);
                  if (roomId != null) {
                    List<dynamic> checkListAllItem = await FunctionUtils.getCheckListItems();
                    for(int index = 0; index < 4; index++) {
                      List typeItems = checkListAllItem[index];
                      List items = [];
                      for (var item in typeItems) {
                        items.add({
                          'id': uuid.v4(),
                          'month': item['month'],
                          'content': item['content'],
                          'has_comment': false,
                          'is_complete': false,
                        });
                      }
                      await CheckListFirestore.setCheckList(index, roomId, items);
                    }
                  }
                  if(!mounted) return;
                  Navigator.pop(context);
                },
                child: const Text('作成')
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextEditingController partnerEmailController = TextEditingController();
}
