import 'dart:math';

import 'package:checklist_child_grow_up/utils/advertisement/rewarded_advertisement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../model/check_list.dart';
import '../../utils/firestore/check_lists.dart';
import '../../utils/loading/change_button.dart';
import '../../utils/loading/loading_button.dart';
import '../../utils/widget_utils.dart';
import 'congratulations_screen.dart';

class AchievementButtonWidget extends StatefulWidget {
  final CheckList checkList;
  final Item item;
  const AchievementButtonWidget({Key? key, required this.checkList, required this.item}) : super(key: key);

  @override
  State<AchievementButtonWidget> createState() => _AchievementButtonWidgetState();
}

class _AchievementButtonWidgetState extends State<AchievementButtonWidget> {
  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();
  final rewardAd = RewardedAdvertisement();
  final random = Random();

  @override
  void initState() {
    super.initState();
    rewardAd.loadRewardedAd();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
      child: LoadingButton(
        btnController: btnController,
        onPressed: () async {
          Item updateItem = Item(
            id: widget.item.id,
            month: widget.item.month,
            isAchieved: !widget.item.isAchieved,
            content: widget.item.content,
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
          widget.item.isAchieved
            ? null
            : await showDialog(context: context, builder: (context) {
              return CongratulationScreen(itemContent: widget.item.content);
            });
          !widget.item.isAchieved && random.nextInt(29) == 0 ? rewardAd.showRewardedAd() : null;
          if(!mounted) return;
          Navigator.pop(context);
        },
        color: widget.item.isAchieved ? Colors.grey.shade100 : Theme.of(context).colorScheme.secondary,
        child: widget.item.isAchieved
          ? const Text('達成をキャンセル', style: TextStyle(color: Colors.black54))
          : const Text('達成')
      ),
    );
  }
}
