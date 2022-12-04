import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../utils/loading/change_button.dart';
import '../../utils/loading/loading_button.dart';

class SendEmailVerificationAlertDialog extends StatefulWidget {
  const SendEmailVerificationAlertDialog({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<SendEmailVerificationAlertDialog> createState() => _SendEmailVerificationAlertDialogState();
}

class _SendEmailVerificationAlertDialogState extends State<SendEmailVerificationAlertDialog> {
  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('メール認証が完了していません'),
      content: const Text('メールアドレス確認用のメールを再度送信しますか?'),
      actions: [
        Column(
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                  primary: Colors.black87,
                  minimumSize: const Size(150, 36),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                  )
              ),
              child: const Text('キャンセル'),
            ),
            LoadingButton(
              btnController: btnController,
              onPressed: () async {
                widget.user.sendEmailVerification();
                if(!mounted) return;
                await ChangeButton.showSuccessFor1Seconds(btnController);
                if(!mounted) return;
                return Navigator.pop(context);
              },
              child: const Text('メール送信')
            ),
          ],
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
