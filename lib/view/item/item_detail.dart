import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/utils/firestore/authentications.dart';
import 'package:checklist_child_grow_up/utils/firestore/check_lists.dart';
import 'package:checklist_child_grow_up/utils/widget_utils.dart';
import 'package:checklist_child_grow_up/view/banner/ad_banner.dart';
import 'package:checklist_child_grow_up/view/item/text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../model/account.dart';
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
  TextEditingController commentController = TextEditingController();
  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();
  Account myAccount = AuthenticationFirestore.myAccount!;
  String getImagePathFromType(int type) {
    switch(type) {
      case 0:
        return 'assets/images/hiyoko_run.png';
      case 1:
        return 'assets/images/hiyoko_crayon.png';
      case 2:
        return 'assets/images/hiyoko_voice.png';
      case 3:
        return 'assets/images/hiyoko_heart.png';
      default:
        return 'assets/images/hiyoko_dance.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    String imagePath = getImagePathFromType(widget.checkList.type);

    Future congratulationDialog() async {
      showDialog(context: context, builder: (context) {
        return const CongratulationScreen();
      });
      await Future.delayed(const Duration(milliseconds: 1500));
      if(!mounted) return;
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: WidgetUtils.createAppBar(''),
      body: SafeArea(
        child: Column(
          children: [
            Center(child: Image.asset(imagePath, height: 80)),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text('「　${widget.item.content}　」',  style: const TextStyle(fontSize: 18, color: Colors.black87))),
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
                if (result) {
                  widget.item.isComplete ? null : await congratulationDialog();
                  if(!mounted) return;
                  Navigator.pop(context);
                }
              },
              color: widget.item.isComplete ? Colors.grey : Theme.of(context).colorScheme.secondary,
              child: widget.item.isComplete ? const Text('達成をキャンセル') : const Text('達成')
            ),
            const SizedBox(height: 30),
            const AdBanner(),
            const Divider(),
            CommentWidget(
              roomId: widget.checkList.roomId,
              checkListId: widget.checkList.id,
              itemId: widget.item.id,
              myAccount: myAccount
            ),
            TextInputWidget(
              commentController: commentController,
              item: widget.item,
              checkList: widget.checkList
            )
          ],
        ),
      ),
    );
  }
}
