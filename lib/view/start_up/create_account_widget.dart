
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
      height: 500,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(color: Colors.black87),
          title: Text('アカウント作成', style: Theme.of(context).textTheme.subtitle1),
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close)
            )
          ],
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                            labelText: 'ユーザ名',
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
                            WidgetUtils.errorSnackBar(context, '正しく入力されていない項目があります');
                            return ChangeButton.showErrorFor4Seconds(btnController);
                          }
                          final signUpResult = await AuthenticationFirestore.signUp(
                              name: nameController.text,
                              email: emailController.text,
                              password: passwordController.text
                          );
                          if (signUpResult is! UserCredential) {
                            if(!mounted) return;
                            WidgetUtils.errorSnackBar(context, signUpResult);
                            return ChangeButton.showErrorFor4Seconds(btnController);
                          }
                          signUpResult.user!.sendEmailVerification();
                          final newAccount = Account(
                              id: signUpResult.user!.uid,
                              name: nameController.text,
                              email: emailController.text
                          );
                          final accountResult = await AccountFirestore.setAccount(newAccount);
                          if (!accountResult) {
                            if(!mounted) return;
                            WidgetUtils.errorSnackBar(context, 'アカウントの作成に失敗しました');
                            AuthenticationFirestore.deleteAuth(signUpResult.user!);
                            return ChangeButton.showErrorFor4Seconds(btnController);
                          }
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
