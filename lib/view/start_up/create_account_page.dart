import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/utils/firestore/authentications.dart';
import 'package:checklist_child_grow_up/utils/firestore/users.dart';
import 'package:checklist_child_grow_up/utils/widget_utils.dart';
import 'package:checklist_child_grow_up/view/start_up/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../model/account.dart';
import '../../utils/loading/loading_button.dart';
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
  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();

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
                LoadingButton(
                  btnController: btnController,
                  onPressed: () async {
                    if(!formKey.currentState!.validate()) {
                      btnController.error();
                      if(!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        WidgetUtils.errorSnackBar('アカウントの作成に失敗しました')
                      );
                      await Future.delayed(const Duration(milliseconds: 4000));
                      btnController.reset();
                      return;
                    }
                    var signUpResult = await AuthenticationFirestore.signUp(
                      email: emailController.text,
                      password: passwordController.text
                    );
                    if (signUpResult is! UserCredential) {
                      btnController.error();
                      if(!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        WidgetUtils.errorSnackBar(signUpResult)
                      );
                      await Future.delayed(const Duration(milliseconds: 4000));
                      btnController.reset();
                      return;
                    }
                    Account newAccount = Account(
                      id: signUpResult.user!.uid,
                      name: nameController.text,
                      createdTime: Timestamp.now(),
                    );
                    var setUserResult = await UserFirestore.setUser(newAccount);
                    if(setUserResult) {
                      btnController.success();
                      await Future.delayed(const Duration(milliseconds: 1500));
                      if(!mounted) return;
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(
                          builder: (context) => const LoginPage()
                      )
                      );
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
