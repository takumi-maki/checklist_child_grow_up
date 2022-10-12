import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/utils/firestore/authentications.dart';
import 'package:checklist_child_grow_up/utils/firestore/check_lists.dart';
import 'package:checklist_child_grow_up/utils/firestore/rooms.dart';
import 'package:checklist_child_grow_up/utils/function_utils.dart';
import 'package:checklist_child_grow_up/utils/validator.dart';
import 'package:checklist_child_grow_up/utils/widget_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:uuid/uuid.dart';

import '../../model/room.dart';
import '../../utils/loading/loading_button.dart';

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({Key? key}) : super(key: key);

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  User user = AuthenticationFirestore.currentFirebaseUser!;
  TextEditingController childNameController = TextEditingController();
  TextEditingController partnerEmailController = TextEditingController();
  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();
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
              LoadingButton(
                btnController: btnController,
                onPressed: () async {
                  if(!formKey.currentState!.validate()) {
                    btnController.error();
                    ScaffoldMessenger.of(context).showSnackBar(
                      WidgetUtils.errorSnackBar('ルームの作成に失敗しました')
                    );
                    await Future.delayed(const Duration(milliseconds: 4000));
                    btnController.reset();
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
                  } else {
                    if(!mounted) return;
                    btnController.error();
                    ScaffoldMessenger.of(context).showSnackBar(
                        WidgetUtils.errorSnackBar('ルームの作成に失敗しました')
                    );
                    await Future.delayed(const Duration(milliseconds: 4000));
                    btnController.reset();
                    return;
                  }
                  btnController.success();
                  await Future.delayed(const Duration(milliseconds: 1500));
                  if(!mounted) return;
                  Navigator.pop(context);
                },
                child: const Text('ルーム作成', style: TextStyle(color: Colors.white))
              )
            ],
          ),
        ),
      ),
    );
  }
}
