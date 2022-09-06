import 'package:demo_sns_app/utils/authentication.dart';
import 'package:demo_sns_app/utils/firestore/users.dart';
import 'package:demo_sns_app/utils/widget_utils.dart';
import 'package:demo_sns_app/view/screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckEmailPage extends StatefulWidget {
  final String email;
  final String password;
  const CheckEmailPage({Key? key, required this.email, required this.password})
      : super(key: key);

  @override
  State<CheckEmailPage> createState() => _CheckEmailPageState();
}

class _CheckEmailPageState extends State<CheckEmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('メールアドレスを確認'),
      body: Column(
        children: [
          const Text('登録したメールアドレスあてに確認のメールを送信しております。'),
          const Text('そちらに記載されているURLをクリックして認証をお願いします。'),
          ElevatedButton(
            onPressed: () async {
              var result = await Authentication.emailSignIn(
                email: widget.email,
                password: widget.password
              );
              if (result is UserCredential) {
                if(result.user!.emailVerified) {
                  while(Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                  await UserFirestore.getUser(result.user!.uid);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Screen()));
                } else {
                  debugPrint('メール認証が終わっていません');
                }
              }
            },

            child: const Text('認証完了'))

        ],
      ),
    );
  }
}
