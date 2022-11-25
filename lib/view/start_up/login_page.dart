import 'package:checklist_child_grow_up/utils/firestore/authentications.dart';
import '../../utils/loading/change_button.dart';
import 'package:checklist_child_grow_up/utils/validator.dart';
import 'package:checklist_child_grow_up/utils/widget_utils.dart';
import 'package:checklist_child_grow_up/view/room/room_list_page.dart';
import 'package:checklist_child_grow_up/view/start_up/create_account_page.dart';
import 'package:checklist_child_grow_up/view/start_up/password_reset_email_page.dart';
import 'package:checklist_child_grow_up/view/start_up/title_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../utils/loading/loading_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void resetControllers() {
    emailController.clear();
    passwordController.clear();
    btnController.reset();
    formKey.currentState?.reset();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  const TitleWidget(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                      decoration: const InputDecoration(
                        labelText: 'パスワード',
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 14.0),
                  RichText(text: TextSpan(
                    style: Theme.of(context).textTheme.bodyText1,
                    children: [
                      const TextSpan(text: 'アカウントを作成していない方は'),
                      TextSpan(text: 'こちら',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CreateAccountPage())
                          );
                          resetControllers();
                        }
                      ),
                    ]
                  )),
                  const SizedBox(height: 8.0),
                  RichText(text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1,
                      children: [
                        const TextSpan(text: 'パスワードの再設定は'),
                        TextSpan(text: 'こちら',
                            style: const TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const PasswordRestEmailPage())
                              );
                              resetControllers();
                            }
                        ),
                      ]
                  )),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: LoadingButton(
                      btnController: btnController,
                      onPressed: () async {
                        if(!formKey.currentState!.validate()) {
                          WidgetUtils.errorSnackBar(context, '正しく入力されていない項目があります');
                          return ChangeButton.showErrorFor4Seconds(btnController);
                        }
                        var signInResult = await AuthenticationFirestore.emailSignIn(email: emailController.text, password: passwordController.text);
                        if(signInResult is! UserCredential) {
                          if(!mounted) return;
                          WidgetUtils.errorSnackBar(context, signInResult);
                          return ChangeButton.showErrorFor4Seconds(btnController);
                        }
                        if(!signInResult.user!.emailVerified) {
                          if(!mounted) return;
                          WidgetUtils.errorSnackBar(context, 'メール認証が終了していません');
                          return ChangeButton.showErrorFor4Seconds(btnController);
                        }
                        await ChangeButton.showSuccessFor1Seconds(btnController);
                        if(!mounted) return;
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RoomListPage()
                            )
                        );
                      },
                      child: const Text('ログイン')
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}