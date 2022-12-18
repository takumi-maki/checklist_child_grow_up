import 'package:age_calculator/age_calculator.dart';
import 'package:checklist_child_grow_up/utils/widget_utils.dart';
import 'package:checklist_child_grow_up/view/room/room_list_card_detail_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/utils/firestore/rooms.dart';
import 'package:checklist_child_grow_up/view/room/create_room_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/check_list.dart';
import '../../model/room.dart';
import '../../utils/firestore/authentications.dart';
import '../widget_utils/app_bar/app_bar_widget.dart';


class RoomListPage extends StatefulWidget {
  const RoomListPage({Key? key}) : super(key: key);

  @override
  State<RoomListPage> createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  final User currentFirebaseUser = AuthenticationFirestore.currentFirebaseUser!;

  List<CheckListProgress> countCheckListsProgress(
    List<QueryDocumentSnapshot<Object?>> checkListDocuments
  ) {
    return checkListDocuments.map((doc) {
      Map<String, dynamic> checkList = doc.data() as Map<String, dynamic>;
      final List items = checkList['items'];
      int isAchievedItemsCount = 0;
      for (var item in items) {
        if (item['is_achieved']) {
          isAchievedItemsCount ++;
        }
      }
      return CheckListProgress(
          type: intToCheckListType(checkList['type']),
          totalItemsCount: items.length,
          isAchievedItemsCount: isAchievedItemsCount
      );
    }).toList();
  }

  int? calculateAgeMonths(DateTime birthdate) {
    final age = AgeCalculator.age(birthdate);
    final ageMonths = age.years * 12 + age.months;
    if (ageMonths < 0) return null;
    return ageMonths;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: 'ルーム一覧'),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: RoomFirestore.rooms
            .where('registered_email_addresses', arrayContains: currentFirebaseUser.email)
            .orderBy('birthdate', descending: true)
            .snapshots(),
          builder: (context, roomSnapshot) {
            if(!roomSnapshot.hasData) {
              return Container(
                color: Colors.white,
                child: Center(
                  child: WidgetUtils.circularProgressIndicator()
                ),
              );
            }
            if(roomSnapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(Icons.info_outline, color: Colors.black54),
                    ),
                    Text('登録しているルームが存在しません'),
                    Padding(
                      padding: EdgeInsets.only(bottom: 50.0),
                      child: Text('右下のボタンからルームを作成してください'),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: roomSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> data = roomSnapshot.data!.docs[index].data() as Map<String, dynamic>;
                final Room room = Room(
                  id: data['id'],
                  childName: data['child_name'],
                  birthdate: data['birthdate'],
                  registeredEmailAddresses: data['registered_email_addresses'],
                  imagePath: data['image_path']
                );
                final ageMonths = calculateAgeMonths(room.birthdate.toDate());
                return StreamBuilder<QuerySnapshot>(
                  stream: RoomFirestore.rooms.doc(room.id)
                    .collection('check_lists').orderBy('type', descending: false)
                    .snapshots(),
                  builder: (context, checkListSnapshot) {
                    if (!checkListSnapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 164.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      );
                    }
                    final List<CheckListProgress> checkListsProgress =
                      countCheckListsProgress(checkListSnapshot.data!.docs);
                    return RoomListCardDetailWidget(
                      room: room,
                      ageMonths: ageMonths,
                      checkListsProgress: checkListsProgress
                    );
                  }
                );
              }
            );
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.0)
              )
            ),
            isScrollControlled: true,
            isDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom
                ),
                child: const CreateRoomWidget(),
              );
            }
          );
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.add),
      ),
    );
  }
}