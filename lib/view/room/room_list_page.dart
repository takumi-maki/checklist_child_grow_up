import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/utils/firestore/rooms.dart';
import 'package:checklist_child_grow_up/view/banner/ad_banner.dart';
import 'package:checklist_child_grow_up/view/room/create_room_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/firestore/authentications.dart';
import '../start_up/login_page.dart';
import '../check_list/check_list_tab_bar_widget.dart';

class RoomListPage extends StatefulWidget {
  const RoomListPage({Key? key}) : super(key: key);

  @override
  State<RoomListPage> createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  User user = AuthenticationFirestore.currentFirebaseUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black54),
        title: const Text('ルーム一覧', style: TextStyle(color: Colors.black54)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => {
              AuthenticationFirestore.signOut(),
              Navigator.pushReplacement(
                context, MaterialPageRoute(
                  builder: (context) => const LoginPage()
                )
              )
            },
          ),
        ],

      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: RoomFirestore.rooms
              .where('joined_accounts', arrayContains: user.email)
              .orderBy('created_time', descending: true)
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
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: roomSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data = roomSnapshot.data!.docs[index].data() as Map<String, dynamic>;
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Image.asset('assets/images/hiyoko_up.png', height: 36),
                              title: Text('${data['child_name']} の ルーム'),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => RoomTabBarWidget(
                                        childName: data['child_name'],
                                        roomId: roomSnapshot.data!.docs[index].id)
                                    )
                                );
                              },
                            ),
                          ),
                        );
                      }
                    ),
                  ),
                  const AdBanner(),
                ],
              );
          } else {
            return Container();
          }
        }
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.only(bottom: 54.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateRoomPage()));
          },
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}