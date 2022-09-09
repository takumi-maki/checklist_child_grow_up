
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_sns_app/utils/firestore/rooms.dart';
import 'package:demo_sns_app/view/room/create_room_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/authentication.dart';
import '../../utils/widget_utils.dart';
import '../start_up/login_page.dart';
import 'room_tab_bar.dart';

class RoomListPage extends StatefulWidget {
  const RoomListPage({Key? key}) : super(key: key);

  @override
  State<RoomListPage> createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  User user = Authentication.currentFirebaseUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black54),
        title: Text('ルーム一覧', style: const TextStyle(color: Colors.black54)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Authentication.signOut();
              while(Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            icon: Icon(Icons.logout)
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: RoomFirestore.rooms
              .where('joined_accounts', arrayContains: user.email)
              .snapshots(),
        builder: (context, roomSnapshot) {
          if(roomSnapshot.hasData) {
            if(roomSnapshot.data!.docs.isEmpty) {
                return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('登録しているルームが存在しません'),
                        Text('右下のボタンからルームを作成してください')
                      ],
                    ),
                );
              }
              return ListView.builder(
                itemCount: roomSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = roomSnapshot.data!.docs[index].data() as Map<String, dynamic>;
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Icon(Icons.bedroom_baby),
                        title: Text('${data['child_name']} の ルーム'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => RoomTabBar(
                                  childName: data['child_name'],
                                  roomId: roomSnapshot.data!.docs[index].id)
                              )
                          );
                        },
                      ),
                    ),
                  );
                }
            );
          } else {
            return Container();
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateRoomPage()));
        },
        backgroundColor: Colors.grey,
        child: const Icon(Icons.add),
      ),
    );

  }
}
