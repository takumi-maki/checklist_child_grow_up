
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_sns_app/utils/authentication.dart';
import 'package:demo_sns_app/utils/firestore/users.dart';
import 'package:demo_sns_app/utils/function_utils.dart';
import 'package:demo_sns_app/utils/widget_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/account.dart';
import '../../utils/loading_dialog.dart';
import '../../utils/loading_elevated_button.dart';


class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('新規登録'),
      body: SingleChildScrollView(
        child: SizedBox(
            width: double.infinity,
          child: Column(
            children: [
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
              LoadingElevatedButton(
                onPressed: () async {
                  await showLoadingDialog(context);
                  if(nameController.text.isNotEmpty
                    && emailController.text.isNotEmpty
                    && passwordController.text.isNotEmpty
                    ) {
                    // Authenticationにユーザーを登録
                    var userCredential = await Authentication.signUp(email: emailController.text, password: passwordController.text);
                    if (userCredential is UserCredential) {
                      Account newAccount = Account(
                        id: userCredential.user!.uid,
                        name: nameController.text,
                        createdTime: Timestamp.now(),
                      );
                      // firestoreにユーザー情報を追加
                      var resultSetUser = await UserFirestore.setUser(newAccount);
                      if(resultSetUser) {
                        hideLoadingDialog();
                        if(!mounted) return;
                        Navigator.of(context).pop;
                      }
                    }
                  }
                },
                child: const Text('アカウントを作成'))
            ],
          ),
        ),
      ),
    );
  }
}
