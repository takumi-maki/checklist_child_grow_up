
import 'dart:io';

import 'package:checklist_child_grow_up/model/account.dart';
import 'package:checklist_child_grow_up/utils/firestore/accounts.dart';
import 'package:checklist_child_grow_up/utils/firestore/authentications.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../utils/firebase_storage/images.dart';
import '../../utils/loading/change_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../utils/validator.dart';
import '../widget_utils/app_bar/modal_bottom_sheet_app_bar_widget.dart';
import '../widget_utils/loading/loading_button.dart';
import '../widget_utils/snack_bar/error_snack_bar_widget.dart';
import 'check_email_page.dart';


class CreateAccountWidget extends StatefulWidget {
  const CreateAccountWidget({Key? key}) : super(key: key);

  @override
  State<CreateAccountWidget> createState() => _CreateAccountWidgetState();
}

class _CreateAccountWidgetState extends State<CreateAccountWidget> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();
  File? compressedImage;
  String? imagePath;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: const ModalBottomSheetAppBarWidget(title: 'アカウント作成'),
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
                                      backgroundColor: Colors.orange.shade200,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Image.asset(
                                          'assets/images/chicken.png',
                                        ),
                                      ),
                                    )
                                    : CircleAvatar(
                                      backgroundColor: Colors.orange.shade200,
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
                          controller: nameController,
                          validator: (value) {
                            return Validator.getRequiredValidatorMessage(value);
                          },
                          decoration: const InputDecoration(
                            labelText: 'アカウント名',
                            labelStyle: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
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
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            return Validator.getPasswordValidatorMessage(value);
                          },
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'パスワード',
                            labelStyle: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, bottom: 70.0),
                      child: LoadingButton(
                        btnController: btnController,
                        onPressed: () async {
                          if(!formKey.currentState!.validate()) {
                            final validationErrorSnackBar = ErrorSnackBar(context, title: '正しく入力されていない項目があります');
                            ScaffoldMessenger.of(context).showSnackBar(validationErrorSnackBar);
                            return ChangeButton.showErrorFor4Seconds(btnController);
                          }
                          final signUpResult = await AuthenticationFirestore.signUp(
                              name: nameController.text,
                              email: emailController.text,
                              password: passwordController.text
                          );
                          if (signUpResult is! UserCredential) {
                            if (!mounted) return;
                            final signUpErrorSnackBar = ErrorSnackBar(context, title: signUpResult);
                            ScaffoldMessenger.of(context).showSnackBar(signUpErrorSnackBar);
                            return ChangeButton.showErrorFor4Seconds(btnController);
                          }
                          if (compressedImage != null) {
                            TaskSnapshot? uploadImageTaskSnapshot = await ImageFirebaseStorage.uploadImage(compressedImage!);
                            if (uploadImageTaskSnapshot == null) {
                              if (!mounted) return;
                              final uploadImageErrorSnackBar = ErrorSnackBar(context, title: '画像の登録に失敗しました');
                              ScaffoldMessenger.of(context).showSnackBar(uploadImageErrorSnackBar);
                              AuthenticationFirestore.deleteAuth(signUpResult.user!);
                              return ChangeButton.showErrorFor4Seconds(btnController);
                            }
                            imagePath = await uploadImageTaskSnapshot.ref.getDownloadURL();
                          }
                          final newAccount = Account(
                            id: signUpResult.user!.uid,
                            name: nameController.text,
                            email: emailController.text,
                            imagePath: imagePath,
                          );
                          final accountResult = await AccountFirestore.setAccount(newAccount);
                          if (!accountResult) {
                            if (!mounted) return;
                            final setNewAccountErrorSnackBar = ErrorSnackBar(context, title: 'アカウントの作成に失敗しました');
                            ScaffoldMessenger.of(context).showSnackBar(setNewAccountErrorSnackBar);
                            AuthenticationFirestore.deleteAuth(signUpResult.user!);
                            if (newAccount.imagePath != null) {
                              ImageFirebaseStorage.deleteImage(newAccount.imagePath!);
                            }
                            return ChangeButton.showErrorFor4Seconds(btnController);
                          }
                          signUpResult.user!.sendEmailVerification();
                          await ChangeButton.showSuccessFor1Seconds(btnController);
                          if(!mounted) return;
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                            builder: (context) => CheckEmailPage(email: emailController.text, password: passwordController.text)
                          ), (_) => false);
                        },
                        child: const Text('作成')
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
