import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_sns_app/model/room.dart';
import 'package:demo_sns_app/utils/firestore/rooms.dart';
import 'package:flutter/material.dart';

import '../../model/check_list.dart';
import '../../utils/authentication.dart';
import '../room/room_member_email_list_page.dart';
import '../start_up/login_page.dart';
import 'check_list_widget.dart';

class RoomTabBarWidget extends StatefulWidget {
final String childName;
final String roomId;
  const RoomTabBarWidget({Key? key, required this.childName, required this.roomId}) : super(key: key);

  @override
  State<RoomTabBarWidget> createState() => _RoomTabBarWidgetState();
}

class _RoomTabBarWidgetState extends State<RoomTabBarWidget> {
  List<Map> tabBarList = [
    {
      'text': 'からだ',
      'imagePath': 'assets/images/hiyoko_run.png'
    },
    {
      'text': 'ゆびさき',
      'imagePath': 'assets/images/hiyoko_crayon.png'
    },
    {
      'text': 'ことば',
      'imagePath': 'assets/images/hiyoko_voice.png'
    },
    {
      'text': 'こうどう',
      'imagePath': 'assets/images/hiyoko_heart.png'
    },
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: tabBarList.length,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.black54),
            elevation: 0,
            title: Text('${widget.childName} の ルーム', style: TextStyle(color: Colors.black54)),
            centerTitle: true,
            actions: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: PopupMenuButton<CheckListPopupMenuItem>(
                    onSelected: (CheckListPopupMenuItem value) {
                      switch(value) {
                        case CheckListPopupMenuItem.memberList:
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RoomMemberEmailListPage(roomId: widget.roomId)));
                      }
                    },
                    child: Icon(Icons.menu),
                    itemBuilder: (context) => <PopupMenuEntry<CheckListPopupMenuItem>>[
                      PopupMenuItem(
                          value: CheckListPopupMenuItem.memberList,
                          child: Text('登録しているメールアドレス一覧')
                      ),
                    ]
                ),
              ),
            ],

            bottom: PreferredSize(
              preferredSize: Size.fromHeight(80.0),
              child: TabBar(
                labelColor: Colors.redAccent,
                indicatorColor: Colors.redAccent,
                unselectedLabelColor: Colors.black54,
                tabs: tabBarList.map((image) {
                  return SizedBox(
                    height: 70.0,
                      child: Tab(child: Column(
                      children: [
                        CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage(image['imagePath'])
                        ),
                        Text(image['text']),
                      ],
                    ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: RoomFirestore.rooms.doc(widget.roomId)
              .collection('check_lists').orderBy('type', descending: false)
              .snapshots(),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return TabBarView(
                  children: snapshot.data!.docs.map((doc) {
                    CheckList checkList = CheckList(id: doc['id'], roomId: doc['room_id'], type: doc['type']);
                    return CheckListWidget(checkList: checkList);
                  }).toList()
                );
              } else {
                return TabBarView(
                  children: tabBarList.map((element) {
                    return Container();
                  }).toList()
                );
              }
            }
          ),
      )
    );
  }
}
