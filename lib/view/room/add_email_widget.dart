import '../../utils/loading/change_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/utils/firestore/rooms.dart';
import 'package:checklist_child_grow_up/utils/validator.dart';
import 'package:checklist_child_grow_up/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../model/room.dart';
import '../../utils/loading/loading_button.dart';

class AddEmailWidget extends StatefulWidget {
  const AddEmailWidget({Key? key, required this.roomId}) : super(key: key);

  final String roomId;

  @override
  State<AddEmailWidget> createState() => _RoomAddEmailPageState();
}

class _RoomAddEmailPageState extends State<AddEmailWidget> {
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
    return SizedBox(
      height: 400,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(color: Colors.black87),
          title: Text('メールアドレス追加', style: Theme.of(context).textTheme.subtitle1),
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close)
            )
          ],
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: SizedBox(
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
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: LoadingButton(
                        btnController: btnController,
                        onPressed: () async {
                          if(!formKey.currentState!.validate()) {
                            WidgetUtils.errorSnackBar(context, '正しく入力されていない項目があります');
                            return ChangeButton.showErrorFor4Seconds(btnController);
                          }
                          if(emailController.text.isNotEmpty) {
                            DocumentSnapshot documentSnapshot = await RoomFirestore.rooms.doc(widget.roomId).get();
                            Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
                            List<dynamic> registeredEmailAddresses;
                            registeredEmailAddresses = data['registered_email_addresses'];
                            if(registeredEmailAddresses.contains(emailController.text)) {
                              if(!mounted) return;
                              WidgetUtils.errorSnackBar(context, '既に登録済みのメールアドレスです');
                              return ChangeButton.showErrorFor4Seconds(btnController);
                            }
                            registeredEmailAddresses.add(emailController.text);
                            Room updateRoom = Room(
                                id: widget.roomId,
                                childName: data['child_name'],
                                registeredEmailAddresses: registeredEmailAddresses,
                                createdTime: data['created_time'],
                                imagePath: data['image_path']

                            );
                            var result = await RoomFirestore.updateRoom(updateRoom);
                            if(!result) {
                              if(!mounted) return;
                              WidgetUtils.errorSnackBar(context, 'メールアドレスの追加に失敗しました');
                              return ChangeButton.showErrorFor4Seconds(btnController);
                            }
                            await ChangeButton.showSuccessFor1Seconds(btnController);
                            if(!mounted) return;
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('追加')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
