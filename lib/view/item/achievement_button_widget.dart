import 'package:checklist_child_grow_up/utils/function_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../model/check_list.dart';
import '../../utils/advertisement/rewarded_interstitial_ad_manager.dart';
import '../../utils/firestore/check_lists.dart';
import '../../utils/loading/change_button.dart';
import '../widget_utils/loading/loading_button.dart';
import '../widget_utils/snack_bar/error_snack_bar_widget.dart';
import 'congratulations_screen.dart';

class AchievementButtonWidget extends StatefulWidget {
  final CheckList checkList;
  final Item item;

  const AchievementButtonWidget(
      {Key? key, required this.checkList, required this.item})
      : super(key: key);

  @override
  State<AchievementButtonWidget> createState() =>
      _AchievementButtonWidgetState();
}

class _AchievementButtonWidgetState extends State<AchievementButtonWidget> {
  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();
  late final bool isAchieved;
  RewardedInterstitialAdManager rewardedInterstitialAdManager =
      RewardedInterstitialAdManager();

  @override
  void initState() {
    super.initState();
    isAchieved = widget.item.isAchieved;
    if (!isAchieved) rewardedInterstitialAdManager.loadAd();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
      child: LoadingButton(
          btnController: btnController,
          onPressed: () async {
            final List<Item> updatedItems = widget.checkList.items.map((item) {
              return widget.item.id == item.id
                  ? Item(
                      id: item.id,
                      month: item.month,
                      isAchieved: !item.isAchieved,
                      content: item.content,
                      achievedTime: item.isAchieved ? null : Timestamp.now())
                  : Item(
                      id: item.id,
                      month: item.month,
                      isAchieved: item.isAchieved,
                      content: item.content,
                      achievedTime: item.achievedTime);
            }).toList();
            var updateItemsResult = await CheckListFirestore.updateItems(
                updatedItems, widget.checkList);
            if (!updateItemsResult) {
              if (!mounted) return;
              final updateErrorSnackBar =
                  ErrorSnackBar(context, title: 'アイテム更新に失敗しました');
              ScaffoldMessenger.of(context).showSnackBar(updateErrorSnackBar);
              return ChangeButton.showErrorFor4Seconds(btnController);
            }
            await ChangeButton.showSuccessFor1Seconds(btnController);
            widget.item.isAchieved
                ? await showDialog(
                    context: context,
                    builder: (context) {
                      return CongratulationScreen(
                          itemContent: widget.item.content);
                    })
                : null;
            if (!mounted) return;
            Navigator.pop(context);
            var randomInt = FunctionUtils.generateRandomInt(3);
            if (randomInt == 0) {
              rewardedInterstitialAdManager.showAd();
            }
          },
          color: isAchieved
              ? Colors.grey.shade100
              : Theme.of(context).colorScheme.secondary,
          child: isAchieved
              ? const Text('達成をキャンセル', style: TextStyle(color: Colors.black54))
              : const Text('達成')),
    );
  }
}
