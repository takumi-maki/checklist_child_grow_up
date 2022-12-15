import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/account.dart';
import '../../utils/firestore/accounts.dart';
import '../../utils/firestore/authentications.dart';
import '../../utils/widget_utils.dart';
import 'edit_account_forms_widget.dart';

class EditAccountWidget extends StatefulWidget {
  const EditAccountWidget({Key? key}) : super(key: key);

  @override
  State<EditAccountWidget> createState() => _EditAccountWidgetState();
}

class _EditAccountWidgetState extends State<EditAccountWidget> {
  final User currentFirebaseUser = AuthenticationFirestore.currentFirebaseUser!;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 520,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: WidgetUtils.createModalBottomSheetAppBar(context, 'アカウント編集'),
        body: SafeArea(
          child: Center(
            child: StreamBuilder<DocumentSnapshot>(
              stream: AccountFirestore.accounts.doc(currentFirebaseUser.uid).snapshots(),
              builder: (context, accountSnapshot) {
                if (!accountSnapshot.hasData) {
                  return const SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.amber),
                    ),
                  );
                }
                Map<String, dynamic> data = accountSnapshot.data!.data() as Map<String, dynamic>;
                final Account account = Account(
                    id: data['id'],
                    name: data['name'],
                    email: data['email'],
                    imagePath: data['image_path']
                );
                return EditAccountFormsWidget(account: account);
              }
            ),
          ),
        ),
      ),
    );
  }
}
