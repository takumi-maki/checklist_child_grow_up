import 'package:checklist_child_grow_up/utils/firestore/authentications.dart';
import 'package:checklist_child_grow_up/utils/firestore/users.dart';
import 'package:checklist_child_grow_up/utils/validator.dart';
import 'package:checklist_child_grow_up/utils/widget_utils.dart';
import 'package:checklist_child_grow_up/view/room/room_list_page.dart';
import 'package:checklist_child_grow_up/view/start_up/create_account_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../utils/loading/loading_elevated_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/images/hiyoko_memo.png', height: 300, width: 350),
                      const Positioned(
                          left: 90,
                          top: 125,
                          child: Text('welcome', style: TextStyle(fontSize: 14, letterSpacing: 3.0))
                      ),
                      const Positioned(
                        left:  90,
                        top: 185,
                        child: Text('わが子の', style: TextStyle(fontSize: 14, letterSpacing: 3.0))
                      ),
                      const Positioned(
                          left: 110,
                          top: 210,
                          child: Text('成長チェックリスト', style: TextStyle(fontSize: 14, letterSpacing: 3.0))
                      ),
                    ],
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
                          hintText: 'メールアドレス',
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
                        hintText: 'パスワード'
                      ),
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  RichText(text: TextSpan(
                    style: const TextStyle(color: Colors.black54),
                    children: [
                      const TextSpan(text: 'アカウントを作成していない方は'),
                      TextSpan(text: 'こちら',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const CreateAccountPage())
                          );
                        }
                      ),
                    ]
                  )),
                  const SizedBox(height: 50),
                  LoadingElevatedButton(
                    onPressed: () async {
                      if(!formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          WidgetUtils.errorSnackBar('ログインに失敗しました')
                        );
                        return;
                      }
                      // await showLoadingDialog(context);
                      var signInResult = await AuthenticationFirestore.emailSignIn(email: emailController.text, password: passwordController.text);
                      if(signInResult is! UserCredential) {
                        if(!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                            WidgetUtils.errorSnackBar(signInResult)
                        );
                        return;
                      }
                      var getUserResult = await UserFirestore.getUser(signInResult.user!.uid);
                      if (getUserResult) {
                        if(!mounted) return;
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const RoomListPage())
                        );
                      }
                     },
                    child: const Text('ログイン')
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
