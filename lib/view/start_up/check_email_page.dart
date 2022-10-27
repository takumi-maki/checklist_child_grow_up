import 'package:checklist_child_grow_up/utils/firestore/authentications.dart';
import 'package:checklist_child_grow_up/utils/loading/loading_button.dart';
import 'package:checklist_child_grow_up/utils/widget_utils.dart';
import 'package:checklist_child_grow_up/view/room/room_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../utils/function_utils.dart';

class CheckEmailPage extends StatefulWidget {
  final String email;
  final String password;
  const CheckEmailPage({Key? key, required this.email, required this.password}) : super(key: key);

  @override
  State<CheckEmailPage> createState() => _CheckEmailPageState();
}

class _CheckEmailPageState extends State<CheckEmailPage> {
  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: WidgetUtils.createAppBar('メールアドレス確認'),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                child: Text(
                  '登録したメールアドレス(${widget.email})あてに確認のメールを送信しました。',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ),
              Image.asset('assets/images/hiyoko_mail.png', height: 150),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
                child: Divider()
              ),
              const SizedBox(height: 10.0),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 3.0),
                child: Text('受信したメールに記載されているURLをクリックして認証をお願いします。')
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 3.0),
                child: Text('認証完了後、下のボタンからログインしてください。')
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 3.0),
                child: Text('( 迷惑メールフォルダに可能性がありますので、そちらもご確認ください。)')
              ),
              const SizedBox(height: 36.0),
              LoadingButton(
                btnController: btnController,
                onPressed: () async {
                  var signInResult = await AuthenticationFirestore.emailSignIn(
                      email: widget.email,
                      password: widget.password
                  );
                  if(signInResult is! UserCredential) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      WidgetUtils.errorSnackBar(signInResult)
                    );
                    return FunctionUtils.showErrorButtonFor4Seconds(btnController);
                  }
                  if(!signInResult.user!.emailVerified) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      WidgetUtils.errorSnackBar('メール認証が終了していません')
                    );
                    return FunctionUtils.showErrorButtonFor4Seconds(btnController);
                  }
                  await FunctionUtils.showSuccessButtonFor1Seconds(btnController);
                  if (!mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RoomListPage()
                    )
                  );
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
