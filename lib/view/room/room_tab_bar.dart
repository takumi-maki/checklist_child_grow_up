import 'package:demo_sns_app/model/room.dart';
import 'package:flutter/material.dart';

import '../check_list/check_list.dart';

class RoomTabBar extends StatefulWidget {
final String childName;
final String roomId;
  const RoomTabBar({Key? key, required this.childName, required this.roomId}) : super(key: key);

  @override
  State<RoomTabBar> createState() => _RoomTabBarState();
}

class _RoomTabBarState extends State<RoomTabBar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.black54),
            elevation: 0,
            title: Text('${widget.childName} の ルーム', style: TextStyle(color: Colors.black54)),
            centerTitle: true,

            bottom: const TabBar(
              labelColor: Colors.redAccent,
              indicatorColor: Colors.redAccent,
              unselectedLabelColor: Colors.black54,
              tabs: [
                Tab(icon: Icon(Icons.accessibility_new), text: 'からだ'),
                Tab(icon: Icon(Icons.pan_tool), text: 'ゆびさき'),
                Tab(icon: Icon(Icons.record_voice_over), text: 'ことば'),
                Tab(icon: Icon(Icons.favorite), text: 'こうどう'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              CheckListPage(type: 1, roomId: widget.roomId),
              CheckListPage(type: 1, roomId: widget.roomId),
              CheckListPage(type: 1, roomId: widget.roomId),
              CheckListPage(type: 1, roomId: widget.roomId),
            ],
          ),
        )
    );
  }
}
