import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/utils/firestore/rooms.dart';
import 'package:checklist_child_grow_up/utils/widget_utils.dart';
import 'package:checklist_child_grow_up/view/banner/ad_banner_widget.dart';
import 'package:checklist_child_grow_up/view/room/add_email_page.dart';
import 'package:flutter/material.dart';

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
      appBar: WidgetUtils.createAppBar(context, '登録中のメールアドレス一覧'),
      body: StreamBuilder<DocumentSnapshot>(
        stream: RoomFirestore.rooms.doc(widget.roomId).snapshots(),
        builder: (context, roomSnapshot) {
          if(!roomSnapshot.hasData) {
            return const SizedBox();
          }
          List<dynamic> emailList = roomSnapshot.data!['joined_accounts'];
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: emailList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Image.asset('assets/images/chicken.png', height: 36),
                              title: Text(emailList[index]),
                            ),
                          ),
                        );
                      }),
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
          onPressed: () async {
            if(!mounted) return;
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddEmailPage(roomId: widget.roomId)));
          },
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
