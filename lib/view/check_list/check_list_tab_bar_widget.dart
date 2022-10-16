import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/utils/firestore/rooms.dart';
import 'package:checklist_child_grow_up/view/check_list/check_list_page_action_menus.dart';
import 'package:flutter/material.dart';

import '../../model/check_list.dart';
import 'check_list_widget.dart';

class RoomTabBarWidget extends StatefulWidget {
final String childName;
final String roomId;
  const RoomTabBarWidget({Key? key, required this.childName, required this.roomId}) : super(key: key);

  @override
  State<RoomTabBarWidget> createState() => _RoomTabBarWidgetState();
}

class _RoomTabBarWidgetState extends State<RoomTabBarWidget> {
  final List<Map> tabBarList = [
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
      'text': 'せいかつ',
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
            title: Text('${widget.childName} の ルーム', style: const TextStyle(color: Colors.black54)),
            centerTitle: true,
            actions: [
              CheckListPageActionMenus(childName: widget.childName, roomId: widget.roomId)
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80.0),
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
                // ルーム削除中エラーを出力しないための応急処置
                if (snapshot.data!.docs.length < 4) {
                  return TabBarView(
                      children: tabBarList.map((element) {
                        return Container();
                      }).toList()
                  );
                }
                return TabBarView(
                  children: snapshot.data!.docs.map((doc) {
                    List<Item> items = [];
                    doc['items'].forEach((element) {
                      Item item = Item(
                        id: element['id'],
                        month: element['month'],
                        isComplete: element['is_complete'],
                        content: element['content'],
                        hasComment: element['has_comment'],
                        completedTime: element['completed_time']
                      );
                      items.add(item);
                    });
                    CheckList checkList = CheckList(id: doc['id'], roomId: doc['room_id'], type: doc['type'], items: items);
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
