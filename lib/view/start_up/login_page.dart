import 'package:demo_sns_app/view/account/account_page.dart';
import 'package:demo_sns_app/view/start_up/create_account_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
              const Text('Flutter SNS', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54)),
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
                          MaterialPageRoute(builder: (context) => CreateAccountPage())
                      );
                    }
                  ),
                ]
              )),
              const SizedBox(height: 70),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Screen())
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith((states) => Colors.grey)
                ),
                child: const Text('emailでログイン')
              ),
            ],
          ),
        ),
      ),
    );
  }
}
