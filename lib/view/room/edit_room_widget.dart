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
import '../widget_utils/app_bar/modal_bottom_sheet_app_bar_widget.dart';
import '../widget_utils/loading/loading_button.dart';

class EditRoomWidget extends StatefulWidget {
  const EditRoomWidget({Key? key, required this.roomId, required this.childName}) : super(key: key);

  final String roomId;
  final String childName;

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
  void initState() {
    super.initState();
    childNameController = TextEditingController(text: widget.childName);
  }

  @override
  void dispose() {
    childNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 520,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: const ModalBottomSheetAppBarWidget(title: 'ルーム編集'),
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
                        child: WidgetUtils.circularProgressIndicator()
                      );
                    }
                    Map<String, dynamic> data = roomSnapshot.data!.data() as Map<String, dynamic>;
                    final Room room = Room(
                        id: data['id'],
                        childName: data['child_name'],
                        birthdate: data['birthdate'],
                        registeredEmailAddresses: data['registered_email_addresses'],
                        imagePath: data['image_path']
                    );
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
                                  WidgetUtils.errorSnackBar(context, '画像の登録に失敗しました');
                                  return ChangeButton.showErrorFor4Seconds(btnController);
                                }
                                imagePath = await uploadImageTaskSnapshot.ref.getDownloadURL();
                              }
                              Room updatedRoom = Room(
                                id: room.id,
                                childName: childNameController.text,
                                birthdate: room.birthdate,
                                registeredEmailAddresses: room.registeredEmailAddresses,
                                imagePath: imagePath ?? room.imagePath,
                              );
                              var updateRoomResult = await RoomFirestore.updateRoom(updatedRoom);
                              if (!updateRoomResult) {
                                if(!mounted) return;
                                WidgetUtils.errorSnackBar(context, 'ルームの編集に失敗しました');
                                return ChangeButton.showErrorFor4Seconds(btnController);
                              }
                              // 画像変更を含むルーム更新が成功した場合、元の画像データ(Storageデータ)を削除
                              if (compressedImage != null && room.imagePath != null) {
                                await ImageFirebaseStorage.deleteImage(room.imagePath!);
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
