import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../utils/firestore/authentications.dart';
import '../../utils/loading/change_button.dart';
import '../../utils/validator.dart';
import '../../utils/widget_utils.dart';
import '../widget_utils/loading/loading_button.dart';

class PasswordRestEmailWidget extends StatefulWidget {
  const PasswordRestEmailWidget({Key? key}) : super(key: key);

  @override
  State<PasswordRestEmailWidget> createState() => _PasswordRestEmailWidgetState();
}

class _PasswordRestEmailWidgetState extends State<PasswordRestEmailWidget> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: WidgetUtils.createModalBottomSheetAppBar(context, 'パスワード再設定'),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: LoadingButton(
                        btnController: btnController,
                        onPressed: () async {
                          if(!formKey.currentState!.validate()) {
                            WidgetUtils.errorSnackBar(context, '正しく入力されていない項目があります');
                            return ChangeButton.showErrorFor4Seconds(btnController);
                          }
                          var passwordRestResult = await AuthenticationFirestore.sendPasswordRestEmail(emailController.text);
                          if (passwordRestResult != 'success') {
                            if(!mounted) return;
                            WidgetUtils.errorSnackBar(context, passwordRestResult);
                            return ChangeButton.showErrorFor4Seconds(btnController);
                          }
                          await ChangeButton.showSuccessFor1Seconds(btnController);
                          if(!mounted) return;
                          Navigator.pop(context);
                        },
                        child: const Text('送信')
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
