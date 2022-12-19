import 'dart:io';

import 'package:checklist_child_grow_up/utils/function_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/utils/firestore/authentications.dart';
import 'package:checklist_child_grow_up/utils/firestore/rooms.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import '../../utils/firebase_storage/images.dart';
import '../../utils/loading/change_button.dart';
import 'package:checklist_child_grow_up/utils/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:uuid/uuid.dart';

import '../../model/room.dart';
import '../widget_utils/app_bar/modal_bottom_sheet_app_bar_widget.dart';
import '../widget_utils/loading/loading_button.dart';
import '../widget_utils/snack_bar/error_snack_bar_widget.dart';

class CreateRoomWidget extends StatefulWidget {
  const CreateRoomWidget({Key? key}) : super(key: key);

  @override
  State<CreateRoomWidget> createState() => _CreateRoomWidgetState();
}

class _CreateRoomWidgetState extends State<CreateRoomWidget> {
  final User currentFirebaseUser = AuthenticationFirestore.currentFirebaseUser!;
  TextEditingController childNameController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();
  TextEditingController partnerEmailController = TextEditingController();
  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();
  final formKey = GlobalKey<FormState>();
  var uuid = const Uuid();
  DateTime? birthdate;
  File? compressedImage;
  String? imagePath;

  @override
  void dispose() {
    childNameController.dispose();
    birthdateController.dispose();
    partnerEmailController.dispose();
    super.dispose();
  }

  Future<void> pickBirthdate() async {
    final DateTime? pickedDate = await FunctionUtils.pickDateFromDatePicker(
      context: context,
      initialDate: DateTime.now()
    );
    if (pickedDate != null) {
       birthdateController.text = DateFormat('yyyy年MM月dd日').format(pickedDate);
       setState(() {
         birthdate = pickedDate;
       });
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 580,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: const ModalBottomSheetAppBarWidget(title: 'ルーム作成'),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        var image = await ImageFirebaseStorage.selectImage();
                        compressedImage = await ImageFirebaseStorage.compressImage(image);
                        setState((){});
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
                                child: compressedImage == null
                                  ? CircleAvatar(
                                    backgroundColor: Colors.green.shade200,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.asset(
                                        'assets/images/hiyoko_up.png',
                                      ),
                                    ),
                                  )
                                  : CircleAvatar(
                                    backgroundColor: Colors.grey.shade200,
                                    backgroundImage: FileImage(compressedImage!)
                                  ),
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
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: birthdateController,
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            pickBirthdate();
                          },
                          validator: (value) {
                            return Validator.getRequiredValidatorMessage(value);
                          },
                          decoration: const InputDecoration(
                            labelText: '生年月日 (必須)',
                            labelStyle: TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
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
                              final validationErrorSnackBar = ErrorSnackBar(context, title: '正しく入力されていない項目があります');
                              ScaffoldMessenger.of(context).showSnackBar(validationErrorSnackBar);
                              return ChangeButton.showErrorFor4Seconds(btnController);
                            }
                            if (compressedImage != null) {
                              TaskSnapshot? uploadImageTaskSnapshot = await ImageFirebaseStorage.uploadImage(compressedImage!);
                              if (uploadImageTaskSnapshot == null) {
                                if (!mounted) return;
                                final uploadImageErrorSnackBar = ErrorSnackBar(context, title: '画像の登録に失敗しました');
                                ScaffoldMessenger.of(context).showSnackBar(uploadImageErrorSnackBar);
                                return ChangeButton.showErrorFor4Seconds(btnController);
                              }
                              imagePath = await uploadImageTaskSnapshot.ref.getDownloadURL();
                            }
                            List<dynamic> registeredEmailAddresses =  partnerEmailController.text.isEmpty
                                ? [currentFirebaseUser.email]
                                : [currentFirebaseUser.email, partnerEmailController.text];
                            Room newRoom = Room(
                              id: uuid.v4(),
                              childName: childNameController.text,
                              birthdate: Timestamp.fromDate(birthdate!),
                              registeredEmailAddresses: registeredEmailAddresses,
                              imagePath: imagePath,
                            );
                            var setNewRoomResult = await RoomFirestore.setNewRoom(newRoom);
                            if (!setNewRoomResult) {
                              if (!mounted) return;
                              final setNewRoomErrorSnackBar = ErrorSnackBar(context, title: 'ルームの作成に失敗しました');
                              ScaffoldMessenger.of(context).showSnackBar(setNewRoomErrorSnackBar);
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
