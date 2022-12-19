import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../utils/firestore/authentications.dart';
import '../../utils/loading/change_button.dart';
import '../../utils/validator.dart';
import '../widget_utils/app_bar/modal_bottom_sheet_app_bar_widget.dart';
import '../widget_utils/loading/loading_button.dart';
import '../widget_utils/snack_bar/error_snack_bar_widget.dart';

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
        appBar: const ModalBottomSheetAppBarWidget(title: 'パスワード再設定'),
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
                            final validationErrorSnackBar = ErrorSnackBar(context, title: '正しく入力されていない項目があります');
                            ScaffoldMessenger.of(context).showSnackBar(validationErrorSnackBar);
                            return ChangeButton.showErrorFor4Seconds(btnController);
                          }
                          var passwordRestResult = await AuthenticationFirestore.sendPasswordRestEmail(emailController.text);
                          if (passwordRestResult != 'success') {
                            if (!mounted) return;
                            final passwordRestErrorSnackBar = ErrorSnackBar(context, title: passwordRestResult);
                            ScaffoldMessenger.of(context).showSnackBar(passwordRestErrorSnackBar);
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
