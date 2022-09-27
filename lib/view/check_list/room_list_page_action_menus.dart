import 'package:flutter/material.dart';

import '../../model/room.dart';
import '../../utils/firestore/authentications.dart';
import '../start_up/login_page.dart';

class RoomListPageActionMenus extends StatelessWidget {
  const RoomListPageActionMenus({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: PopupMenuButton<RoomListPopupMenuItem>(
          onSelected: (RoomListPopupMenuItem value) {
            switch(value) {
              case RoomListPopupMenuItem.signOut:
                AuthenticationFirestore.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
            }
          },
          child: const Icon(Icons.menu),
          itemBuilder: (context) => <PopupMenuEntry<RoomListPopupMenuItem>>[
            PopupMenuItem(
                value: RoomListPopupMenuItem.signOut,
                child: const Text('ログアウト')
            )
          ]
      ),
    );
  }
}
