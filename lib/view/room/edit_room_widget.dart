import 'dart:io';

import 'package:checklist_child_grow_up/utils/firestore/rooms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../utils/firebase_storage/images.dart';
import '../../utils/loading/change_button.dart';
import 'package:checklist_child_grow_up/utils/validator.dart';
import 'package:checklist_child_grow_up/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../model/room.dart';
import '../../utils/loading/loading_button.dart';

class EditRoomWidget extends StatefulWidget {
  const EditRoomWidget({Key? key, required this.roomId}) : super(key: key);

  final String roomId;

  @override
  State<EditRoomWidget> createState() => _EditRoomWidgetState();
}

class _EditRoomWidgetState extends State<EditRoomWidget> {
  TextEditingController childNameController = TextEditingController();
  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();
  final formKey = GlobalKey<FormState>();
  File? compressedImage;
  String? imagePath;

  @override
  void dispose() {
    childNameController.dispose();
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
          title: Text('ルーム編集', style: Theme.of(context).textTheme.subtitle1),
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
                child: StreamBuilder<DocumentSnapshot>(
                  stream: RoomFirestore.rooms.doc(widget.roomId).snapshots(),
                  builder: (context, roomSnapshot) {
                    if (!roomSnapshot.hasData) {
                      return Center(
                        child: Column(
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 6.0),
                              child: Icon(Icons.error_outline_rounded, color: Colors.black54),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 6.0),
                              child: Text('ルーム情報の取得に失敗しました'),
                            ),
                          ],
                        ),
                      );
                    }
                    Map<String, dynamic> data = roomSnapshot.data!.data() as Map<String, dynamic>;
                    final Room room = Room(
                        id: data['id'],
                        childName: data['child_name'],
                        registeredEmailAddresses: data['registered_email_addresses'],
                        createdTime: data['created_time'],
                        imagePath: data['image_path']
                    );
                    childNameController = TextEditingController(text: room.childName);
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            var selectedImage = await ImageFirebaseStorage.selectImage();
                            compressedImage = await ImageFirebaseStorage.compressImage(selectedImage);
                            setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: compressedImage != null
                                      ? CircleAvatar(
                                        backgroundColor: Colors.grey.shade200,
                                        backgroundImage: FileImage(compressedImage!),
                                      )
                                      : room.imagePath != null
                                        ? CircleAvatar(
                                          backgroundColor: Colors.grey.shade200,
                                          backgroundImage: NetworkImage(room.imagePath!)
                                        )
                                        : CircleAvatar(
                                          backgroundColor: Colors.green.shade200,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Image.asset(
                                              'assets/images/hiyoko_up.png',
                                            ),
                                          ),
                                        )
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 14.0,
                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                  child: const Icon(Icons.add_a_photo, color: Colors.white, size: 20.0),
                                )
                              ]
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
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
                          padding: const EdgeInsets.symmetric(vertical: 30.0),
                          child: LoadingButton(
                            btnController: btnController,
                            onPressed: () async {
                              if(!formKey.currentState!.validate()) {
                                WidgetUtils.errorSnackBar(context, '正しく入力されていない項目があります');
                                return ChangeButton.showErrorFor4Seconds(btnController);
                              }
                              if (compressedImage != null) {
                                TaskSnapshot? uploadImageTaskSnapshot =
                                  await ImageFirebaseStorage.uploadImage(compressedImage!);
                                if (uploadImageTaskSnapshot == null) {
                                  if(!mounted) return;
                                  WidgetUtils.errorSnackBar(context, '画像の送信に失敗しました');
                                  return;
                                }
                                imagePath = await uploadImageTaskSnapshot.ref.getDownloadURL();
                              }
                              Room updatedRoom = Room(
                                id: room.id,
                                childName: childNameController.text,
                                registeredEmailAddresses: room.registeredEmailAddresses,
                                createdTime: room.createdTime,
                                imagePath: imagePath ?? room.imagePath,
                              );
                              var updateRoomResult = await RoomFirestore.updateRoom(updatedRoom);
                              if (!updateRoomResult) {
                                if(!mounted) return;
                                WidgetUtils.errorSnackBar(context, 'ルームの作成に失敗しました');
                                return ChangeButton.showErrorFor4Seconds(btnController);
                              }
                              await ChangeButton.showSuccessFor1Seconds(btnController);
                              if(!mounted) return;
                              Navigator.pop(context);
                            },
                            child: const Text('編集', style: TextStyle(color: Colors.white))
                          ),
                        )
                      ],
                    );
                  }
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}