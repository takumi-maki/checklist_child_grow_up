import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/utils/firestore/rooms.dart';
import 'package:checklist_child_grow_up/view/check_list/check_list_page_action_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../model/check_list.dart';
import '../../utils/route_utils.dart';
import 'check_list_widget.dart';

class CheckListTabBarWidget extends StatefulWidget {
final String childName;
final String roomId;
  const CheckListTabBarWidget({Key? key, required this.childName, required this.roomId}) : super(key: key);

  @override
  State<CheckListTabBarWidget> createState() => _CheckListTabBarWidgetState();
}

class _CheckListTabBarWidgetState extends State<CheckListTabBarWidget> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  // 遷移先の画面から戻ってきたら再描画する。comments情報を更新するため。
  @override
  void didPopNext() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: CheckList.tabBarList.length,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.black87),
            elevation: 0,
            title: Text('${widget.childName} の ルーム', style: Theme.of(context).textTheme.subtitle1),
            centerTitle: true, systemOverlayStyle: SystemUiOverlayStyle.dark,
            actions: [
              CheckListPageActionMenus(childName: widget.childName, roomId: widget.roomId)
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80.0),
              child: TabBar(
                labelColor: Theme.of(context).colorScheme.secondary,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                indicatorColor: Theme.of(context).colorScheme.secondary,
                unselectedLabelColor: Colors.black87,
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
                tabs: CheckList.tabBarList.map((tabBar) {
                  return SizedBox(
                    height: 70.0,
                      child: Tab(child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage(tabBar['imagePath'])
                        ),
                        Text(tabBar['text'], style: const TextStyle(fontSize: 12), softWrap: false),
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
              if(!snapshot.hasData || snapshot.data!.docs.length < CheckList.tabBarList.length) {
                return TabBarView(
                  children: CheckList.tabBarList.map((e) {
                    return const SizedBox();
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
                      isAchieved: element['is_achieved'],
                      content: element['content'],
                      achievedTime: element['achieved_time']
                    );
                    items.add(item);
                  });
                  CheckList checkList = CheckList(id: doc['id'], roomId: doc['room_id'], type: doc['type'], items: items);
                  return CheckListWidget(checkList: checkList);
                }).toList()
              );
            }
          ),
      )
    );
  }
}
