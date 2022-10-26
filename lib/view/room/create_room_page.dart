import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/utils/firestore/authentications.dart';
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
  User loginUser = AuthenticationFirestore.currentFirebaseUser!;
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
                    labelText: '子供の名前 (必須)',
                    labelStyle: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: partnerEmailController,
                  validator: (value) {
                    return Validator.getPartnerEmailValidatorMessage(value, loginUser.email);
                  },
                  decoration: const InputDecoration(
                    labelText: 'パートナーのメールアドレス',
                    labelStyle: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              LoadingButton(
                btnController: btnController,
                onPressed: () async {
                  if(!formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      WidgetUtils.errorSnackBar('正しく入力されていない項目があります')
                    );
                    return FunctionUtils.showErrorButtonFor4Seconds(btnController);
                  }
                  List<dynamic> joinedAccounts =  partnerEmailController.text.isEmpty
                      ? [loginUser.email]
                      : [loginUser.email, partnerEmailController.text];
                  Room newRoom = Room(
                    id: '',
                    childName: childNameController.text,
                    joinedAccounts: joinedAccounts,
                    createdTime: Timestamp.now(),
                  );
                  var setNewRoomResult = await RoomFirestore.setNewRoom(newRoom);
                  if (!setNewRoomResult) {
                    if(!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      WidgetUtils.errorSnackBar('ルームの作成に失敗しました')
                    );
                    return FunctionUtils.showErrorButtonFor4Seconds(btnController);
                  }
                  await FunctionUtils.showSuccessButtonFor1Seconds(btnController);
                  if(!mounted) return;
                  Navigator.pop(context);
                },
                child: const Text('作成', style: TextStyle(color: Colors.white))
              )
            ],
          ),
        ),
      ),
    );
  }
}
