import 'dart:io';

import 'package:checklist_child_grow_up/utils/firestore/rooms.dart';
import 'package:checklist_child_grow_up/view/check_list/bulk_achieve_check_list_dialog.dart';
import 'package:checklist_child_grow_up/view/check_list/check_lists_app_bar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';

import '../../model/check_list.dart';
import '../../utils/firestore/authentications.dart';
import '../banner/ad_banner_widget.dart';
import 'check_list_card_detail_widget.dart';

class CheckListsPageWidget extends StatefulWidget {
  const CheckListsPageWidget(
      {Key? key, required this.childName, this.ageMonths, required this.roomId})
      : super(key: key);

  final String childName;
  final int? ageMonths;
  final String roomId;

  @override
  State<CheckListsPageWidget> createState() => _CheckListsPageWidgetState();
}

class _CheckListsPageWidgetState extends State<CheckListsPageWidget> {
  final User currentFirebaseUser = AuthenticationFirestore.currentFirebaseUser!;

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

  final RateMyApp _rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 7,
    minLaunches: 10,
    remindDays: 7,
    remindLaunches: 10,
  );

  void _initRateMyApp() {
    _rateMyApp.init().then((_) {
      if (_rateMyApp.shouldOpenDialog) {
        if (Platform.isAndroid) {
          _rateMyApp.showRateDialog(context,
              ignoreNativeDialog: Platform.isAndroid,
              title: '0~3歳までの成長のチェックリスト',
              message: 'はいかがですか? 左下のボタンから Google Play のページで評価していただけると大変嬉しいです。',
              rateButton: '評価する',
              laterButton: 'あとで通知',
              noButton: '今はしない');
        } else {
          _rateMyApp.showRateDialog(context);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initRateMyApp();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: CheckList.tabBarList.length,
        child: Scaffold(
          appBar: CheckListsAppBarWidget(
              ageMonths: widget.ageMonths, roomId: widget.roomId),
          body: SafeArea(
            child: StreamBuilder<QuerySnapshot>(
                stream: RoomFirestore.rooms
                    .doc(widget.roomId)
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
                        SizedBox(
                            height: 40.0,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: OutlinedButton.icon(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return BulkAchieveCheckListDialog(
                                              checkList: checkList);
                                        });
                                  },
                                  style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0))),
                                  icon: const Icon(
                                    Icons.edit_note,
                                    color: Colors.black87,
                                  ),
                                  label: Text('まとめて達成',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall)),
                            )),
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
                                          unreadCommentsCount:
                                              unreadCommentsCount,
                                        );
                                      }
                                      return CheckListCardDetailWidget(
                                        checkList: checkList,
                                        item: item,
                                        hasComments: false,
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
