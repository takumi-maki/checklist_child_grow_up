import 'package:checklist_child_grow_up/utils/firestore/rooms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../model/check_list.dart';
import '../../utils/widget_utils.dart';
import 'check_list_page_action_menus.dart';

class CheckListsAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const CheckListsAppBarWidget({
    Key? key,
    this.ageMonths,
    required this.roomId
  }) : super(key: key);

  final int? ageMonths;
  final String roomId;

  @override
  Size get preferredSize => const Size.fromHeight(130.0);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: RoomFirestore.rooms.doc(roomId).snapshots(),
      builder: (context, roomSnapshot) {
        if (!roomSnapshot.hasData || !roomSnapshot.data!.exists) {
          return Container(
            color: Colors.white,
            child: Center(
                child: WidgetUtils.circularProgressIndicator()
            ),
          );
        }
        Map<String, dynamic> data = roomSnapshot.data!.data() as Map<String, dynamic>;
        final childName = data['child_name'];
        return AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black87),
          elevation: 0,
          title: Column(
            children: [
              Text('$childName の ルーム', style: Theme.of(context).textTheme.subtitle1),
              ageMonths != null
                ? Text('( $ageMonthsヶ月 )', style: Theme.of(context).textTheme.bodySmall)
                : const SizedBox(),
            ],
          ),
          centerTitle: true, systemOverlayStyle: SystemUiOverlayStyle.dark,
          actions: [
            CheckListPageActionMenus(childName: childName, roomId: roomId)
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
                  child: Tab(
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage(tabBar['imagePath'])
                        ),
                        Text(tabBar['text'], style: const TextStyle(fontSize: 12), softWrap: false),
                      ],
                    )
                  ),
                );
              }).toList(),
            ),
          ),
        );
      }
    );
  }
}
