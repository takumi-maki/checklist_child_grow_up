import 'package:checklist_child_grow_up/view/start_up/title_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/firestore/authentications.dart';
import '../room/room_list_page.dart';
import 'login_page.dart';

class LoginCheck extends StatefulWidget {
  const LoginCheck({Key? key}) : super(key: key);

  @override
  State<LoginCheck> createState() => _LoginCheckState();
}

class _LoginCheckState extends State<LoginCheck> {
  late Future<User?> futureCheckLoginUserAfter3Seconds;

  @override
  void initState() {
    super.initState();
    futureCheckLoginUserAfter3Seconds = AuthenticationFirestore.checkLoginUserAfter3Seconds();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
        future: futureCheckLoginUserAfter3Seconds,
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
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.secondary),
                          ),
                        )
                      ],
                    )
                ),
              ),
            );
          }
          if (snapShot.hasData) {
            return const RoomListPage();
          }
          return const LoginPage();
        });
  }
}