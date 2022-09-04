
import 'dart:io';

import 'package:demo_sns_app/utils/authentication.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

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

  Future<void> getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black54),
        title: const Text('新規登録', style: TextStyle(color: Colors.black54),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  getImageFromGallery();
                },
                child: CircleAvatar(
                  foregroundImage: image == null ? null : FileImage(image!),
                  radius: 40,
                  backgroundColor: Colors.grey,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 40,),
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
                  var result = await Authentication.signUp(email: emailController.text, password: passwordController.text);
                  if (result) {
                    Navigator.pop(context);
                  }
                }
            },
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith((states) => Colors.grey),
              ),
              child: const Text('アカウントを作成'))
          ],
        ),
      ),
    );
  }
}
