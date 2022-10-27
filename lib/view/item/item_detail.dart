import 'dart:async';

import 'package:checklist_child_grow_up/utils/function_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/utils/firestore/check_lists.dart';
import 'package:checklist_child_grow_up/utils/widget_utils.dart';
import 'package:checklist_child_grow_up/view/item/text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../model/check_list.dart';
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
  final int textInputWidgetHeight = 70;
  late String itemImagePath;

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

  @override
  void initState() {
    super.initState();
    itemImagePath = getItemImagePath();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: WidgetUtils.createAppBar(context, 'アイテム詳細'),
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - textInputWidgetHeight,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Center(child: Image.asset(itemImagePath, height: 80)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
                    child: Text('「　${widget.item.content}　」',
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  LoadingButton(
                    btnController: btnController,
                    onPressed: () async {
                      Item updateItem = Item(
                          id: widget.item.id,
                          month: widget.item.month,
                          isComplete: widget.item.isComplete ? false : true,
                          content: widget.item.content,
                          hasComment: widget.item.hasComment,
                          completedTime: widget.item.isComplete ? null : Timestamp.now()
                      );
                      var result = await CheckListFirestore.updateItem(updateItem, widget.checkList);
                      if (!result) {
                        if(!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                            WidgetUtils.errorSnackBar('アイテム更新に失敗しました')
                        );
                        return FunctionUtils.showErrorButtonFor4Seconds(btnController);
                      }
                      await FunctionUtils.showSuccessButtonFor1Seconds(btnController);
                      widget.item.isComplete ? null : await congratulationDialog();
                      if(!mounted) return;
                      Navigator.pop(context);
                    },
                    color: widget.item.isComplete ? Colors.white70 : Theme.of(context).colorScheme.secondary,
                    child: widget.item.isComplete ? const Text('達成をキャンセル', style: TextStyle(color: Colors.black54),) : const Text('達成')
                  ),
                  const SizedBox(height: 16.0),
                  const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                      child: Divider()
                  ),

                  CommentWidget(
                    roomId: widget.checkList.roomId,
                    checkListId: widget.checkList.id,
                    itemId: widget.item.id,
                  ),
                  TextInputWidget(
                    item: widget.item,
                    checkList: widget.checkList
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
