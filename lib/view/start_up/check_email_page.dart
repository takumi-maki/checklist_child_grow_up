import 'package:checklist_child_grow_up/utils/firestore/authentications.dart';
import 'package:checklist_child_grow_up/utils/loading/loading_button.dart';
import 'package:checklist_child_grow_up/utils/widget_utils.dart';
import 'package:checklist_child_grow_up/view/room/room_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../utils/loading/change_button.dart';

class CheckEmailPage extends StatefulWidget {
  final String email;
  final String password;
  const CheckEmailPage({Key? key, required this.email, required this.password}) : super(key: key);

  @override
  State<CheckEmailPage> createState() => _CheckEmailPageState();
}

class _CheckEmailPageState extends State<CheckEmailPage> {
  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();
  final double _horizontalMargin = 40.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar(context, 'メールアドレス確認'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: _horizontalMargin),
                  child: Text(
                    '【 ${widget.email} 】宛に、確認のメールを送信しました。',
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  child: Image.asset('assets/images/hiyoko_mail.png', height: 130),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: _horizontalMargin),
                  child: const Text('\n ・ メールに記載されているURLをクリックして、認証をお願いします。')
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: _horizontalMargin),
                  child: const Text('\n ・ 認証完了後、下のボタンからログインしてください。')
                ),
                const SizedBox(height: 10.0),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: _horizontalMargin),
                  child: const Divider()
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Icon(Icons.error_outline_rounded, color: Colors.black54),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: _horizontalMargin),
                  child: const Text('メールが迷惑フォルダに入る可能性がありますので、そちらもご確認ください。'),
                ),
                const SizedBox(height: 30.0),
                Padding(
                  padding: const EdgeInsets.only(bottom: 80.0),
                  child: LoadingButton(
                    btnController: btnController,
                    onPressed: () async {
                      var signInResult = await AuthenticationFirestore.emailSignIn(
                          email: widget.email,
                          password: widget.password
                      );
                      if(signInResult is! UserCredential) {
                        if (!mounted) return;
                        WidgetUtils.errorSnackBar(context, signInResult);
                        return ChangeButton.showErrorFor4Seconds(btnController);
                      }
                      if(!signInResult.user!.emailVerified) {
                        if (!mounted) return;
                        WidgetUtils.errorSnackBar(context, 'メール認証が完了していません');
                        return ChangeButton.showErrorFor4Seconds(btnController);
                      }
                      await ChangeButton.showSuccessFor1Seconds(btnController);
                      if (!mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RoomListPage()
                        ),
                        (_) => false
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
    );
  }
}
