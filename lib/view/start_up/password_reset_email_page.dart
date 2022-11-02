import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../utils/firestore/authentications.dart';
import '../../utils/loading/change_button.dart';
import '../../utils/loading/loading_button.dart';
import '../../utils/validator.dart';
import '../../utils/widget_utils.dart';

class PasswordRestEmailPage extends StatefulWidget {
  const PasswordRestEmailPage({Key? key}) : super(key: key);

  @override
  State<PasswordRestEmailPage> createState() => _PasswordRestEmailPageState();
}

class _PasswordRestEmailPageState extends State<PasswordRestEmailPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar(context, 'パスワード再設定'),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
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
                        labelText: 'メールアドレス',
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                LoadingButton(
                    btnController: btnController,
                    onPressed: () async {
                      if(!formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            WidgetUtils.errorSnackBar('正しく入力されていない項目があります')
                        );
                        return ChangeButton.showErrorFor4Seconds(btnController);
                      }
                      var passwordRestResult = await AuthenticationFirestore.sendPasswordRestEmail(emailController.text);
                      if (passwordRestResult != 'success') {
                        if(!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                            WidgetUtils.errorSnackBar(passwordRestResult)
                        );
                        return ChangeButton.showErrorFor4Seconds(btnController);
                      }
                      await ChangeButton.showSuccessFor1Seconds(btnController);
                      if(!mounted) return;
                      Navigator.pop(context);
                    },
                    child: const Text('作成')
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
