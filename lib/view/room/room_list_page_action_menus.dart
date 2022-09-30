import 'package:flutter/material.dart';

import '../../model/room.dart';
import '../../utils/firestore/authentications.dart';
import '../start_up/login_page.dart';

class RoomListPageActionMenus extends StatelessWidget {
  const RoomListPageActionMenus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: PopupMenuButton<RoomListPopupMenuItem>(
        onSelected: (RoomListPopupMenuItem value) {
          switch(value) {
            case RoomListPopupMenuItem.signOut:
              AuthenticationFirestore.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
          }
        },
        itemBuilder: (context) => <PopupMenuEntry<RoomListPopupMenuItem>>[
          PopupMenuItem(
              value: RoomListPopupMenuItem.signOut,
              child: Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 15.0),
                  Text('ログアウト'),
                ],
              )
          )
        ],
        offset: const Offset(0.0, 60.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Icon(Icons.menu),
      ),
    );
  }
}
