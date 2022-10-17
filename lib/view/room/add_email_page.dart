import 'dart:async';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('メールアドレス追加'),
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
                    labelText: 'メールアドレス (必須)',
                    labelStyle: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              LoadingButton(
                btnController: btnController,
                onPressed: () async {
                  if(!formKey.currentState!.validate()) {
                    btnController.error();
                    ScaffoldMessenger.of(context).showSnackBar(
                      WidgetUtils.errorSnackBar('メールアドレスの追加に失敗しました')
                    );
                    await Future.delayed(const Duration(milliseconds: 4000));
                    btnController.reset();
                    return;
                  }
                  if(emailController.text.isNotEmpty) {
                    DocumentSnapshot documentSnapshot = await RoomFirestore.rooms.doc(widget.roomId).get();
                    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                    List<dynamic> newJoinedAccounts = data['joined_accounts'];
                    if(newJoinedAccounts.contains(emailController.text)) {
                      btnController.error();
                      if(!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                          WidgetUtils.errorSnackBar('既に登録済みのメールアドレスです')
                      );
                      await Future.delayed(const Duration(milliseconds: 4000));
                      btnController.reset();
                      return;
                    }
                    newJoinedAccounts.add(emailController.text);
                    Room updateRoom = Room(
                        id: widget.roomId,
                        childName: data['child_name'],
                        joinedAccounts: newJoinedAccounts,
                        createdTime: data['created_time']
                    );
                    var result = await RoomFirestore.updateRoom(updateRoom);
                    if(result) {
                      btnController.success();
                      await Future.delayed(const Duration(milliseconds: 1500));
                      if(!mounted) return;
                      Navigator.pop(context);
                    } else {
                      btnController.error();
                      if(!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                          WidgetUtils.errorSnackBar('メールアドレスの追加に失敗しました')
                      );
                      await Future.delayed(const Duration(milliseconds: 4000));
                      btnController.reset();
                      return;
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
