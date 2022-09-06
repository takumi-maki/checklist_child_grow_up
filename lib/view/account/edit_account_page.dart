import 'dart:io';

import 'package:demo_sns_app/utils/authentication.dart';
import 'package:demo_sns_app/utils/firestore/users.dart';
import 'package:demo_sns_app/utils/function_utils.dart';
import 'package:demo_sns_app/utils/widget_utils.dart';
import 'package:demo_sns_app/view/start_up/login_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/account.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({Key? key}) : super(key: key);

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  Account myAccount = Authentication.myAccount!;
  TextEditingController nameController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  TextEditingController selfIntroductionController = TextEditingController();
  File? image;
  ImagePicker picker = ImagePicker();

  ImageProvider getImage() {
    if(image == null) {
      // firestoreに格納された画像 (編集前)
      return NetworkImage(myAccount.imagePath);
    } else {
      // image_pickerから取り出した画像 (編集後)
      return FileImage(image!);
    }
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: myAccount.name);
    userIdController = TextEditingController(text: myAccount.userId);
    selfIntroductionController = TextEditingController(text: myAccount.selfIntroduction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('プロフィール編集'),
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
                    if (pickedFile != null) {
                      setState(() {
                        image = File(pickedFile.path);
                      });
                    }
                  },
                  child: CircleAvatar(
                    foregroundImage: getImage(),
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
              const SizedBox(height: 50),
              ElevatedButton(
                  onPressed: () async {
                    if(nameController.text.isNotEmpty
                        && userIdController.text.isNotEmpty
                        && selfIntroductionController.text.isNotEmpty) {
                      String imagePath = '';
                      if (image == null) {
                        imagePath = myAccount.imagePath;
                      } else {
                        imagePath = await FunctionUtils.uploadImage(myAccount.id, image!);
                      }
                      Account updateAccount = Account(
                        id: myAccount.id,
                        name: nameController.text,
                        userId: userIdController.text,
                        selfIntroduction: selfIntroductionController.text,
                        imagePath: imagePath
                      );
                      // AuthenticationのmyAccountも更新
                      Authentication.myAccount = updateAccount;
                      var result = await UserFirestore.updateUser(updateAccount);
                      if(result) {
                        Navigator.pop(context, true);
                      }
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.grey),
                  ),
                  child: const Text('更新')
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Authentication.signOut();
                  // popできる状態であればpopする
                  while(Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith((states) => Colors.grey),
                ),
                child: const Text('ログアウト')
              ),
            ],
          ),
        ),
      ),
    );
  }
}
