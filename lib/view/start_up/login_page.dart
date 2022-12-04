import 'package:checklist_child_grow_up/utils/firestore/authentications.dart';
import '../../utils/loading/change_button.dart';
import 'package:checklist_child_grow_up/utils/validator.dart';
import 'package:checklist_child_grow_up/utils/widget_utils.dart';
import 'package:checklist_child_grow_up/view/room/room_list_page.dart';
import 'package:checklist_child_grow_up/view/start_up/create_account_widget.dart';
import 'package:checklist_child_grow_up/view/start_up/password_reset_email_widget.dart';
import 'package:checklist_child_grow_up/view/start_up/title_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../utils/loading/loading_button.dart';
import 'send_email_verification_alert_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void resetControllers() {
    emailController.clear();
    passwordController.clear();
    btnController.reset();
    formKey.currentState?.reset();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  const TitleWidget(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        return Validator.getPasswordValidatorMessage(value);
                      },
                      decoration: const InputDecoration(
                        labelText: 'パスワード',
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 14.0),
                  RichText(text: TextSpan(
                    style: Theme.of(context).textTheme.bodyText1,
                    children: [
                      const TextSpan(text: 'アカウントを作成していない方は'),
                      TextSpan(text: 'こちら',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0)
                              )
                            ),
                            isDismissible: false,
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).viewInsets.bottom
                                ),
                                child: const CreateAccountWidget(),
                              );
                          });
                          resetControllers();
                        }
                      ),
                    ]
                  )),
                  const SizedBox(height: 8.0),
                  RichText(text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1,
                      children: [
                        const TextSpan(text: 'パスワードの再設定は'),
                        TextSpan(text: 'こちら',
                            style: const TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.0)
                                  )
                                ),
                                isDismissible: false,
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context).viewInsets.bottom
                                    ),
                                    child: const PasswordRestEmailWidget(),
                                  );
                              });
                              resetControllers();
                            }
                        ),
                      ]
                  )),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: LoadingButton(
                      btnController: btnController,
                      onPressed: () async {
                        if(!formKey.currentState!.validate()) {
                          WidgetUtils.errorSnackBar(context, '正しく入力されていない項目があります');
                          return ChangeButton.showErrorFor4Seconds(btnController);
                        }
                        var signInResult = await AuthenticationFirestore.emailSignIn(email: emailController.text, password: passwordController.text);
                        if(signInResult is! UserCredential) {
                          if(!mounted) return;
                          WidgetUtils.errorSnackBar(context, signInResult);
                          return ChangeButton.showErrorFor4Seconds(btnController);
                        }
                        if(!signInResult.user!.emailVerified) {
                          showDialog(context: context, builder: (context) {
                            return SendEmailVerificationAlertDialog(user: signInResult.user!);
                          });
                          return ChangeButton.showErrorFor4Seconds(btnController);
                        }
                        await ChangeButton.showSuccessFor1Seconds(btnController);
                        if(!mounted) return;
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RoomListPage()
                            )
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
      ),
    );
  }
}