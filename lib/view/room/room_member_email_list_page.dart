import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_sns_app/utils/firestore/rooms.dart';
import 'package:demo_sns_app/utils/firestore/users.dart';
import 'package:demo_sns_app/utils/widget_utils.dart';
import 'package:demo_sns_app/view/room/add_email_page.dart';
import 'package:flutter/material.dart';

import '../../model/account.dart';
import '../../model/room.dart';

class RoomMemberEmailListPage extends StatefulWidget {
  final String roomId;
  const RoomMemberEmailListPage({Key? key, required this.roomId}) : super(key: key);

  @override
  State<RoomMemberEmailListPage> createState() => _RoomMemberEmailListPageState();
}

class _RoomMemberEmailListPageState extends State<RoomMemberEmailListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.createAppBar('登録しているメールアドレス一覧'),
      body: StreamBuilder<DocumentSnapshot>(
        stream: RoomFirestore.rooms.doc(widget.roomId).snapshots(),
        builder: (context, roomSnapshot) {
          if(roomSnapshot.hasData) {
            List<dynamic> emailList = roomSnapshot.data!['joined_accounts'];
            return ListView.builder(
                itemCount: emailList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Image.asset('assets/images/chicken.png', height: 36),
                        title: Text(emailList[index]),
                      ),
                    ),
                  );
                });
          } else {
            return Container();
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddEmailPage(roomId: widget.roomId)));
        },
        backgroundColor: Colors.grey,
        child: const Icon(Icons.add),
      ),
    );
  }
}
