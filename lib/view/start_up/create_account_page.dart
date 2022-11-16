
import 'package:checklist_child_grow_up/model/account.dart';
import 'package:checklist_child_grow_up/utils/firestore/accounts.dart';
import 'package:checklist_child_grow_up/utils/firestore/authentications.dart';
import '../../utils/loading/change_button.dart';
import 'package:checklist_child_grow_up/utils/widget_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../utils/loading/loading_button.dart';
import '../../utils/validator.dart';
import 'check_email_page.dart';


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
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<dynamic> signUpAuthentication() async {
    var signUpResult = await AuthenticationFirestore.signUp(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text
    );
    if (signUpResult is! UserCredential) {
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          WidgetUtils.errorSnackBar(signUpResult)
      );
      return ChangeButton.showErrorFor4Seconds(btnController);
    }
    return signUpResult;
  }

  Future<void> createAccountFirestore(User user) async {
    final newAccount = Account(
        id: user.uid,
        name: nameController.text,
        email: emailController.text
    );
    var accountResult = await AccountFirestore.setAccount(newAccount);
    if (!accountResult) {
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          WidgetUtils.errorSnackBar('アカウントの作成に失敗しました')
      );
      AuthenticationFirestore.delete(user);
      return ChangeButton.showErrorFor4Seconds(btnController);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar(context, 'アカウント作成'),
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
                      labelText: 'ユーザ名',
                      labelStyle: TextStyle(fontSize: 14),
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
                        labelText: 'メールアドレス',
                        labelStyle: TextStyle(fontSize: 14),
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
                      labelText: 'パスワード',
                      labelStyle: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                LoadingButton(
                  btnController: btnController,
                  onPressed: () async {
                    if(!formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        WidgetUtils.errorSnackBar('正しく入力されていない項目があります')
                      );
                      return ChangeButton.showErrorFor4Seconds(btnController);
                    }
                    final signUpResult = await signUpAuthentication();
                    signUpResult.user!.sendEmailVerification();
                    createAccountFirestore(signUpResult.user!);
                    await ChangeButton.showSuccessFor1Seconds(btnController);
                    if(!mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckEmailPage(email: emailController.text, password: passwordController.text)
                      ),
                        (_) => false
                    );
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
