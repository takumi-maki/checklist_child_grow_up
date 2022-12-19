import 'package:checklist_child_grow_up/view/start_up/title_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/firestore/authentications.dart';
import '../room/room_list_page.dart';
import '../widget_utils/loading/circular_progress_indicator_widget.dart';
import 'login_page.dart';

class LoginCheck extends StatefulWidget {
  const LoginCheck({Key? key}) : super(key: key);

  @override
  State<LoginCheck> createState() => _LoginCheckState();
}

class _LoginCheckState extends State<LoginCheck> {
  late Future<User?> futureCheckCurrentFirebaseUser;

  @override
  void initState() {
    super.initState();
    futureCheckCurrentFirebaseUser = AuthenticationFirestore.checkCurrentFirebaseUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
        future: futureCheckCurrentFirebaseUser,
        builder: (context, snapShot) {
          if(snapShot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Container(
                color: Colors.white,
                child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const TitleWidget(),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: CircularProgressIndicatorWidget()
                        ),
                        Text('　読み込み中...', style: Theme.of(context).textTheme.bodySmall)
                      ],
                    )
                ),
              ),
            );
          }
          if (snapShot.hasData && snapShot.data!.emailVerified) {
            return const RoomListPage();
          }
          return const LoginPage();
        });
  }
}
