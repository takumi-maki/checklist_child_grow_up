import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/utils/firestore/authentications.dart';
import 'package:checklist_child_grow_up/utils/firestore/rooms.dart';
import '../../utils/loading/change_button.dart';
import 'package:checklist_child_grow_up/utils/validator.dart';
import 'package:checklist_child_grow_up/utils/widget_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:uuid/uuid.dart';

import '../../model/room.dart';
import '../../utils/loading/loading_button.dart';

class CreateRoomWidget extends StatefulWidget {
  const CreateRoomWidget({Key? key}) : super(key: key);

  @override
  State<CreateRoomWidget> createState() => _CreateRoomWidgetState();
}

class _CreateRoomWidgetState extends State<CreateRoomWidget> {
  final User currentFirebaseUser = AuthenticationFirestore.currentFirebaseUser!;
  TextEditingController childNameController = TextEditingController();
  TextEditingController partnerEmailController = TextEditingController();
  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();
  final formKey = GlobalKey<FormState>();
  var uuid = const Uuid();

  @override
  void dispose() {
    childNameController.dispose();
    partnerEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 460,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(color: Colors.black87),
          title: Text('ルーム作成', style: Theme.of(context).textTheme.subtitle1),
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close)
            ),
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
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: childNameController,
                          validator: (value) {
                            return Validator.getRequiredValidatorMessage(value);
                          },
                          decoration: const InputDecoration(
                            labelText: '子供の名前 (必須)',
                            labelStyle: TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: partnerEmailController,
                          validator: (value) {
                            return Validator.getPartnerEmailValidatorMessage(value, currentFirebaseUser.email);
                          },
                          decoration: const InputDecoration(
                            labelText: 'パートナーのメールアドレス',
                            labelStyle: TextStyle(fontSize: 14.0),
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
                            List<dynamic> registeredEmailAddresses =  partnerEmailController.text.isEmpty
                                ? [currentFirebaseUser.email]
                                : [currentFirebaseUser.email, partnerEmailController.text];
                            Room newRoom = Room(
                              id: uuid.v4(),
                              childName: childNameController.text,
                              registeredEmailAddresses: registeredEmailAddresses,
                              createdTime: Timestamp.now(),
                            );
                            var setNewRoomResult = await RoomFirestore.setNewRoom(newRoom);
                            if (!setNewRoomResult) {
                              if(!mounted) return;
                              WidgetUtils.errorSnackBar(context, 'ルームの作成に失敗しました');
                              return ChangeButton.showErrorFor4Seconds(btnController);
                            }
                            await ChangeButton.showSuccessFor1Seconds(btnController);
                            if(!mounted) return;
                            Navigator.pop(context);
                          },
                          child: const Text('作成', style: TextStyle(color: Colors.white))
                      ),
                    )
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
