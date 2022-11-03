import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/utils/firestore/check_lists.dart';
import 'package:checklist_child_grow_up/utils/widget_utils.dart';
import 'package:checklist_child_grow_up/view/item/text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../model/check_list.dart';
import '../../utils/loading/change_button.dart';
import '../../utils/loading/loading_button.dart';
import 'comment_widget.dart';
import 'congratulation_screen.dart';

class ItemDetail extends StatefulWidget {
  final CheckList checkList;
  final Item item;
  const ItemDetail({Key? key, required this.checkList, required this.item}) : super(key: key);

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();
  late String itemImagePath;

  @override
  void initState() {
    super.initState();
    itemImagePath = getItemImagePath();
  }

  String getItemImagePath() {
    final CheckListType checkListType = intToCheckListType(1);
    final Map<dynamic, dynamic> result = CheckList.tabBarList.firstWhere((tabBar) {
      return tabBar['type'] == checkListType;
    }, orElse: () => {'imagePath': 'assets/images/hiyoko_dance.png'});
    return result['imagePath'];
  }

  Future congratulationDialog() async {
    showDialog(context: context, builder: (context) {
      return const CongratulationScreen();
    });
    await Future.delayed(const Duration(milliseconds: 1500));
    if(!mounted) return;
    Navigator.pop(context);
  }

  Future<Timestamp?> modifyAchievedTime(DateTime achievedTime) async {
    final DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: achievedTime,
      firstDate: DateTime.now().add(const Duration(days: - 3650)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.orange.shade300,
              onSurface: Colors.black87
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Theme.of(context).colorScheme.secondary
              ),
            ),
          ),
          child: child!,
        );
      }
    );
    if (datePicked != null && datePicked != achievedTime) {
      return Timestamp.fromDate(datePicked);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: WidgetUtils.createAppBar(context, 'アイテム詳細'),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.78,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(child: Image.asset(itemImagePath, height: 80)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, top: 10.0, right: 18.0),
                          child: Text('「　${widget.item.content}　」',
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        widget.item.achievedTime == null
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('達成した日 ： ${DateFormat('yyyy/MM/dd').format(widget.item.achievedTime!.toDate())}',
                                    style: const TextStyle(color: Colors.black54),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      final Timestamp? modifiedAchievedTime = await modifyAchievedTime(widget.item.achievedTime!.toDate());
                                      if (modifiedAchievedTime == null) return;
                                      Item updatedItem = Item(
                                        id: widget.item.id,
                                        month: widget.item.month,
                                        isAchieved: widget.item.isAchieved,
                                        content: widget.item.content,
                                        hasComment: widget.item.hasComment,
                                        achievedTime: modifiedAchievedTime,
                                      );
                                      var result = await CheckListFirestore.updateItem(updatedItem, widget.checkList);
                                      if (!result) {
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            WidgetUtils.errorSnackBar('達成した日の更新に失敗しました')
                                        );
                                        return;
                                      }
                                      if(!mounted) return;
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.edit_calendar, size: 18.0, color: Colors.black54))
                                  ],
                              ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
                          child: LoadingButton(
                            btnController: btnController,
                            onPressed: () async {
                              Item updateItem = Item(
                                  id: widget.item.id,
                                  month: widget.item.month,
                                  isAchieved: widget.item.isAchieved ? false : true,
                                  content: widget.item.content,
                                  hasComment: widget.item.hasComment,
                                  achievedTime: widget.item.isAchieved ? null : Timestamp.now()
                              );
                              var result = await CheckListFirestore.updateItem(updateItem, widget.checkList);
                              if (!result) {
                                if(!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                    WidgetUtils.errorSnackBar('アイテム更新に失敗しました')
                                );
                                return ChangeButton.showErrorFor4Seconds(btnController);
                              }
                              await ChangeButton.showSuccessFor1Seconds(btnController);
                              widget.item.isAchieved ? null : await congratulationDialog();
                              if(!mounted) return;
                              Navigator.pop(context);
                            },
                            color: widget.item.isAchieved ? Colors.grey.shade100 : Theme.of(context).colorScheme.secondary,
                            child: widget.item.isAchieved ? const Text('達成をキャンセル', style: TextStyle(color: Colors.black54),) : const Text('達成')
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                            child: Divider()
                        ),
                        CommentWidget(
                          roomId: widget.checkList.roomId,
                          checkListId: widget.checkList.id,
                          itemId: widget.item.id,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              TextInputWidget(
                  item: widget.item,
                  checkList: widget.checkList
              )
            ],
          ),
        ),
      ),
    );
  }
}
