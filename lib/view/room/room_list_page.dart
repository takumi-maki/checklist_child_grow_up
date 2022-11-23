import 'package:checklist_child_grow_up/utils/widget_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/utils/firestore/rooms.dart';
import 'package:checklist_child_grow_up/view/banner/ad_banner_widget.dart';
import 'package:checklist_child_grow_up/view/room/create_room_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/firestore/authentications.dart';
import '../check_list/check_lists_page.dart';

class RoomListPage extends StatefulWidget {
  const RoomListPage({Key? key}) : super(key: key);

  @override
  State<RoomListPage> createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  final User currentFirebaseUser = AuthenticationFirestore.currentFirebaseUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar(context, 'ルーム一覧'),
      body: StreamBuilder<QuerySnapshot>(
        stream: RoomFirestore.rooms
          .where('registered_email_addresses', arrayContains: currentFirebaseUser.email)
          .orderBy('created_time', descending: true)
          .snapshots(),
        builder: (context, roomSnapshot) {
          if(!roomSnapshot.hasData) {
            return const Center(
              child: SizedBox(
                height: 20.0,
                width: 20.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.amber),
                ),
              ),
            );
          }
          if(roomSnapshot.data!.docs.isEmpty) {
            return SafeArea(
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.black54,
                          ),
                        ),
                        Text('登録しているルームが存在しません'),
                        Padding(
                          padding: EdgeInsets.only(bottom: 50.0),
                          child: Text('右下のボタンからルームを作成してください'),
                        ),
                      ],
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomCenter,
                    child: AdBannerWidget()
                  )
                ]
              ),
            );
          }
          return SafeArea(
            child: Column(
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
                              title: Text('${data['child_name']} のルーム'),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              textColor: Colors.black87,
                              iconColor: Colors.black87,
                              onTap: () {
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => CheckListsPageWidget(
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
                const AdBannerWidget(),
              ],
            ),
          );
        }
      ),
      floatingActionButton: Padding(
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