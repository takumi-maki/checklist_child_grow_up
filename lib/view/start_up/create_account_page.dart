import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_sns_app/utils/authentication.dart';
import 'package:demo_sns_app/utils/firestore/users.dart';
import 'package:demo_sns_app/utils/widget_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/account.dart';
import '../../utils/loading/loading_elevated_button.dart';
import '../../utils/validator.dart';


class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('アカウントを作成'),
      body: SingleChildScrollView(
        child: SizedBox(
            width: double.infinity,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: nameController,
                    validator: (value) {
                      return Validator.getRequiredValidatorMessage(value);
                    },
                    decoration: const InputDecoration(
                      hintText: '名前'
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: emailController,
                      validator: (value) {
                        return Validator.getEmailRegValidatorMessage(value);
                      },
                      decoration: const InputDecoration(
                        hintText: 'メールアドレス'
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: passwordController,
                    validator: (value) {
                      return Validator.getPasswordValidatorMessage(value);
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'パスワード'
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                LoadingElevatedButton(
                  onPressed: () async {
                    print('コンテキストは ${context}');
                    if(!formKey.currentState!.validate()) {
                      if(!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        WidgetUtils.errorSnackBar('アカウントの作成に失敗しました')
                      );
                      return;
                    }
                    var signUpResult = await Authentication.signUp(
                      email: emailController.text,
                      password: passwordController.text
                    );
                    if (signUpResult is! UserCredential) {
                      if(!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                          WidgetUtils.errorSnackBar(signUpResult)
                      );
                      return;
                    }
                    Account newAccount = Account(
                      id: signUpResult.user!.uid,
                      name: nameController.text,
                      createdTime: Timestamp.now(),
                    );
                    var setUserResult = await UserFirestore.setUser(newAccount);
                    if(setUserResult) {
                      if(!mounted) return;
                      Navigator.of(context).pop;
                    }
                  },
                  child: const Text('作成')
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
