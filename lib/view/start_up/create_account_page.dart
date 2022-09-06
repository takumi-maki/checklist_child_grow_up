
import 'dart:io';

import 'package:demo_sns_app/utils/authentication.dart';
import 'package:demo_sns_app/utils/firestore/users.dart';
import 'package:demo_sns_app/utils/function_utils.dart';
import 'package:demo_sns_app/utils/widget_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import '../../model/account.dart';
import 'check_email_page.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController selfIntroductionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  File? image;
  ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('新規登録'),
      body: SingleChildScrollView(
        child: SizedBox(
            width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 30),
              SizedBox(
                child: GestureDetector(
                  onTap: () async {
                    var pickedFile = await FunctionUtils.getImageFromGallery();
                    if(pickedFile != null) {
                      setState(() {
                        image = File(pickedFile.path);
                      });
                    }
                  },
                  child: CircleAvatar(
                    foregroundImage: image == null ? null : FileImage(image!),
                    backgroundColor: Colors.grey,
                    radius: 40,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: '名前'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    controller: userIdController,
                    decoration: const InputDecoration(
                        hintText: 'ユーザーID'
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: selfIntroductionController,
                  decoration: const InputDecoration(
                      hintText: '自己紹介'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        hintText: 'メールアドレス'
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                      hintText: 'パスワード'
                  ),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  if(nameController.text.isNotEmpty
                    && userIdController.text.isNotEmpty
                    && selfIntroductionController.text.isNotEmpty
                    && emailController.text.isNotEmpty
                    && passwordController.text.isNotEmpty
                    && image != null) {
                    // Authenticationにユーザーを登録
                    var userCredential = await Authentication.signUp(email: emailController.text, password: passwordController.text);
                    if (userCredential is UserCredential) {
                      String imagePath = await FunctionUtils.uploadImage(userCredential.user!.uid, image!);
                      Account newAccount = Account(
                        id: userCredential.user!.uid,
                        name: nameController.text,
                        userId: userIdController.text,
                        selfIntroduction: selfIntroductionController.text,
                        imagePath: imagePath,
                      );
                      // firestoreにユーザー情報を追加
                      var resultSetUser = await UserFirestore.setUser(newAccount);
                      if(resultSetUser) {
                        userCredential.user!.sendEmailVerification();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckEmailPage(
                              email: emailController.text,
                              password: passwordController.text,
                            )
                          )
                        );
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(primary: Colors.grey),
                child: const Text('アカウントを作成'))
            ],
          ),
        ),
      ),
    );
  }
}
