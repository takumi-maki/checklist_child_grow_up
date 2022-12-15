import 'dart:io';

import 'package:checklist_child_grow_up/model/account.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../utils/firebase_storage/images.dart';
import '../../utils/firestore/accounts.dart';
import '../../utils/firestore/authentications.dart';
import '../../utils/loading/change_button.dart';
import 'package:checklist_child_grow_up/utils/validator.dart';
import 'package:checklist_child_grow_up/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../utils/loading/loading_button.dart';

class EditAccountFormsWidget extends StatefulWidget {
  const EditAccountFormsWidget({Key? key, required this.account}) : super(key: key);

  final Account account;

  @override
  State<EditAccountFormsWidget> createState() => _EditAccountFormsWidgetState();
}

class _EditAccountFormsWidgetState extends State<EditAccountFormsWidget> {

  TextEditingController nameController = TextEditingController();
  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();
  final formKey = GlobalKey<FormState>();
  File? compressedImage;
  String? imagePath;
  String? beforeUpdateImagePath;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.account.name);
    if (widget.account.imagePath != null) {
      beforeUpdateImagePath = widget.account.imagePath;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
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
                          : widget.account.imagePath != null
                            ? CircleAvatar(
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: NetworkImage(widget.account.imagePath!)
                            )
                            : CircleAvatar(
                              backgroundColor: Colors.orange.shade200,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.asset('assets/images/chicken.png'),
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
                  controller: nameController,
                  validator: (value) {
                    return Validator.getRequiredValidatorMessage(value);
                  },
                  decoration: const InputDecoration(
                    labelText: 'ユーザ名 (必須)',
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
                    Account updatedAccount = Account(
                      id: widget.account.id,
                      name: nameController.text,
                      email: widget.account.email,
                      imagePath: imagePath ?? widget.account.imagePath,
                    );
                    final updateAccountResult = await AccountFirestore.updateAccount(updatedAccount);
                    if (!updateAccountResult) {
                      if(!mounted) return;
                      WidgetUtils.errorSnackBar(context, 'アカウントの編集に失敗しました');
                      if (compressedImage != null) {
                        await ImageFirebaseStorage.deleteImage(updatedAccount.imagePath!);
                      }
                      return ChangeButton.showErrorFor4Seconds(btnController);
                    }
                    await AuthenticationFirestore.updateDisplayName(updatedAccount.name);
                    // 画像変更を含むアカウント更新が成功した場合、元の画像データ(Storageデータ)を削除
                    if (compressedImage != null && beforeUpdateImagePath != null) {
                      await ImageFirebaseStorage.deleteImage(beforeUpdateImagePath!);
                    }
                    await ChangeButton.showSuccessFor1Seconds(btnController);
                    if(!mounted) return;
                    Navigator.pop(context);
                  },
                  child: const Text('編集', style: TextStyle(color: Colors.white))
              ),
            )
          ],
        ),
      ),
    );
  }
}
