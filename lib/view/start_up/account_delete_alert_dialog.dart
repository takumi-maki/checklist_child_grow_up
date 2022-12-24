import 'package:checklist_child_grow_up/utils/firestore/accounts.dart';
import 'package:checklist_child_grow_up/utils/firestore/authentications.dart';
import 'package:checklist_child_grow_up/view/start_up/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/loading/change_button.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../utils/validator.dart';
import '../widget_utils/loading/loading_button.dart';
import '../widget_utils/snack_bar/error_snack_bar_widget.dart';

class AccountDeleteAlertDialog extends StatefulWidget {
  const AccountDeleteAlertDialog({Key? key}) : super(key: key);

  @override
  State<AccountDeleteAlertDialog> createState() => _AccountDeleteAlertDialogState();
}

class _AccountDeleteAlertDialogState extends State<AccountDeleteAlertDialog> {
  final formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  RoundedLoadingButtonController btnController = RoundedLoadingButtonController();
  final User currentFirebaseUser = AuthenticationFirestore.currentFirebaseUser!;

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  void deleteErrorHandling(String message) {
    if(!mounted) return;
    Navigator.pop(context);
    final deleteAccountErrorSnackBar = ErrorSnackBar(context, title: message);
    ScaffoldMessenger.of(context).showSnackBar(deleteAccountErrorSnackBar);
    return;
  }

  Future onDeletedAccount() async {
    if(!formKey.currentState!.validate()) {
      return ChangeButton.showErrorFor4Seconds(btnController);
    }
    final myAccount = await AccountFirestore.getMyAccount(currentFirebaseUser.uid);
    if(myAccount == null) {
      return deleteErrorHandling('アカウント情報の取得に失敗しました');
    }
    final deleteAccountResult = await AccountFirestore.deleteAccount(currentFirebaseUser.uid);
    if(!deleteAccountResult) {
      return deleteErrorHandling('アカウントの削除に失敗しました');
    }
    final reAuthResult = await AuthenticationFirestore.reAuthenticate(currentFirebaseUser, passwordController.text);
    if (reAuthResult is! UserCredential) {
      // 先ほど削除したアカウントを作り直す ( Authentication と Firestore の垣根を越えたトランザクション処理ができないため )
      await AccountFirestore.setNewAccount(myAccount);
      return deleteErrorHandling(reAuthResult);
    }
    final deleteAuthResult = await AuthenticationFirestore.deleteAuth(currentFirebaseUser);
    if(!deleteAuthResult) {
      // 先ほど削除したアカウントを作り直す ( Authentication と Firestore の垣根を越えたトランザクション処理ができないため )
      await AccountFirestore.setNewAccount(myAccount);
      return deleteErrorHandling('アカウントの削除に失敗しました');
    }
    await ChangeButton.showSuccessFor1Seconds(btnController);
    if(!mounted) return;
    while(Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    if(!mounted) return;
    Navigator.pushReplacement(
      context, MaterialPageRoute(
        builder: (context) => const LoginPage()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('アカウントの削除'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('本当にあなたのアカウントを削除してもよろしいですか?'),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextFormField(
                controller: passwordController,
                validator: (value) {
                  return Validator.getPasswordValidatorMessage(value);
                },
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'パスワード',
                  labelStyle: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: OutlinedButton(
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
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: LoadingButton(
                btnController: btnController,
                onPressed: () => onDeletedAccount(),
                color: Theme.of(context).errorColor,
                child: const Text('削除')
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ],
    );
  }
}
