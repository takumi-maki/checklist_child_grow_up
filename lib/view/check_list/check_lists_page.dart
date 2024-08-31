import 'package:checklist_child_grow_up/utils/firestore/rooms.dart';
import 'package:checklist_child_grow_up/utils/rate_my_app.dart';
import 'package:checklist_child_grow_up/view/check_list/bulk_achieve_check_list_button_widget.dart';
import 'package:checklist_child_grow_up/view/check_list/check_lists_app_bar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/check_list.dart';
import '../../model/room.dart';
import '../../utils/firestore/authentications.dart';
import '../banner/ad_banner_widget.dart';
import 'check_list_card_detail_widget.dart';

class CheckListsPageWidget extends StatefulWidget {
  const CheckListsPageWidget({Key? key, required this.room}) : super(key: key);

  final Room room;

  @override
  State<CheckListsPageWidget> createState() => _CheckListsPageWidgetState();
}

class _CheckListsPageWidgetState extends State<CheckListsPageWidget> {
  final User currentFirebaseUser = AuthenticationFirestore.currentFirebaseUser!;
  final RateMyAppService _rateMyAppService = RateMyAppService();

  String getChildName(AsyncSnapshot<DocumentSnapshot<Object?>> roomSnapshot) {
    Map<String, dynamic> data =
        roomSnapshot.data!.data() as Map<String, dynamic>;
    return data['child_name'];
  }

  CheckList getCheckList(QueryDocumentSnapshot<Object?> checkListSnapshot) {
    List docItems = checkListSnapshot['items'];
    final List<Item> items = docItems.map((item) {
      return Item(
          id: item['id'],
          month: item['month'],
          isAchieved: item['is_achieved'],
          content: item['content'],
          achievedTime: item['achieved_time']);
    }).toList();
    CheckList checkList = CheckList(
        id: checkListSnapshot['id'],
        roomId: checkListSnapshot['room_id'],
        type: checkListSnapshot['type'],
        items: items);
    return checkList;
  }

  int countUnreadComments(List<QueryDocumentSnapshot> commentSnapshot) {
    int unreadCommentsCount = 0;
    for (final comment in commentSnapshot) {
      Map<String, dynamic> data = comment.data() as Map<String, dynamic>;
      List commentReadAccountIds = data['read_account_ids'];
      if (!commentReadAccountIds.contains(currentFirebaseUser.uid)) {
        unreadCommentsCount++;
      }
    }
    return unreadCommentsCount;
  }

  double getCheckListItemsWidgetHeight() {
    double checkListItemsWidgetHeight;
    const appBarWidgetHeight = 138.0;
    const bulkAchievementWidgetHeight = 40.0;
    const bottomNavigationBarHeight = 64.0;
    checkListItemsWidgetHeight = MediaQuery.of(context).size.height -
        appBarWidgetHeight -
        bulkAchievementWidgetHeight -
        bottomNavigationBarHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    return checkListItemsWidgetHeight;
  }

  @override
  void initState() {
    super.initState();
    _rateMyAppService.initRateMyApp(context);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: CheckList.tabBarList.length,
        child: Scaffold(
          appBar: CheckListsAppBarWidget(
            roomId: widget.room.id,
          ),
          body: SafeArea(
            child: StreamBuilder<QuerySnapshot>(
                stream: RoomFirestore.rooms
                    .doc(widget.room.id)
                    .collection('check_lists')
                    .orderBy('type', descending: false)
                    .snapshots(),
                builder: (context, checkListSnapshot) {
                  if (!checkListSnapshot.hasData ||
                      checkListSnapshot.data!.docs.length <
                          CheckList.tabBarList.length) {
                    return TabBarView(
                        children: CheckList.tabBarList.map((e) {
                      return const SizedBox();
                    }).toList());
                  }
                  return TabBarView(
                      children: checkListSnapshot.data!.docs.map((doc) {
                    CheckList checkList = getCheckList(doc);
                    return Column(
                      children: [
                        BulkAchieveCheckListButtonWidget(checkList: checkList),
                        SizedBox(
                          height: getCheckListItemsWidgetHeight(),
                          child: ListView.builder(
                              itemCount: checkList.items.length,
                              itemBuilder: (context, index) {
                                final Item item = checkList.items[index];
                                return StreamBuilder<QuerySnapshot>(
                                    stream: RoomFirestore.rooms
                                        .doc(checkList.roomId)
                                        .collection('check_lists')
                                        .doc(checkList.id)
                                        .collection('comments')
                                        .orderBy('created_time',
                                            descending: false)
                                        .where('item_id', isEqualTo: item.id)
                                        .snapshots(),
                                    builder: (context, commentSnapshot) {
                                      if (!commentSnapshot.hasData) {
                                        return const SizedBox(
                                          height: 64.0,
                                          width: double.infinity,
                                        );
                                      }
                                      if (commentSnapshot
                                          .data!.docs.isNotEmpty) {
                                        final unreadCommentsCount =
                                            countUnreadComments(
                                                commentSnapshot.data!.docs);
                                        return CheckListCardDetailWidget(
                                          checkList: checkList,
                                          item: item,
                                          hasComments: true,
                                          birthDateTime:
                                              widget.room.birthdate.toDate(),
                                          unreadCommentsCount:
                                              unreadCommentsCount,
                                        );
                                      }
                                      return CheckListCardDetailWidget(
                                        checkList: checkList,
                                        item: item,
                                        hasComments: false,
                                        birthDateTime:
                                            widget.room.birthdate.toDate(),
                                      );
                                    });
                              }),
                        ),
                      ],
                    );
                  }).toList());
                }),
          ),
          bottomNavigationBar: const AdBannerWidget(),
        ));
  }
}
