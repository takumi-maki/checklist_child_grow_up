import 'package:demo_sns_app/utils/authentication.dart';
import 'package:demo_sns_app/utils/firestore/users.dart';
import 'package:demo_sns_app/view/room/room_list_page.dart';
import 'package:demo_sns_app/view/start_up/create_account_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../utils/loading_dialog.dart';
import '../../utils/loading_elevated_button.dart';
import '../screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text('わが子の成長チェックリスト', style: TextStyle(fontSize: 24, color: Colors.black54)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'メールアドレス',
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
              const SizedBox(height: 70),
              LoadingElevatedButton(
                onPressed: () async {
                  await showLoadingDialog(context);
                  var result = await Authentication.emailSignIn(email: emailController.text, password: passwordController.text);
                  if(result is UserCredential) {
                    if(result.user!.emailVerified){
                      var user = await UserFirestore.getUser(result.user!.uid);
                      if (user) {
                        hideLoadingDialog();
                        if(!mounted) return;
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const RoomListPage())
                        );

                      }
                    }
                  }
                },
                child: const Text('ログイン')
              ),
            ],
          ),
        ),
      ),
    );
  }
}
