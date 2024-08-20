import 'package:checklist_child_grow_up/model/check_list.dart';
import 'package:checklist_child_grow_up/utils/firestore/check_lists.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../utils/advertisement/rewarded_interstitial_ad_manager.dart';
import '../../utils/function_utils.dart';
import '../../utils/loading/change_button.dart';
import '../widget_utils/loading/loading_button.dart';
import '../widget_utils/snack_bar/error_snack_bar_widget.dart';

class BulkAchieveCheckListDialog extends StatefulWidget {
  const BulkAchieveCheckListDialog({Key? key, required this.checkList})
      : super(key: key);

  final CheckList checkList;

  @override
  State<BulkAchieveCheckListDialog> createState() =>
      _BulkAchieveCheckListDialogState();
}

class _BulkAchieveCheckListDialogState
    extends State<BulkAchieveCheckListDialog> {
  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();
  late List<bool> isAchieved;
  RewardedInterstitialAdManager rewardedInterstitialAdManager =
      RewardedInterstitialAdManager();

  @override
  void initState() {
    isAchieved = List.generate(widget.checkList.items.length,
        (index) => widget.checkList.items[index].isAchieved);
    rewardedInterstitialAdManager.loadAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Center(
                child: Text('まとめて達成',
                    style: Theme.of(context).textTheme.titleMedium)),
          ),
          CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage:
                  AssetImage(getCheckListTypeImagePath(widget.checkList.type))),
          Text(getCheckListTypeText(widget.checkList.type),
              style: const TextStyle(fontSize: 12), softWrap: false),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            itemCount: widget.checkList.items.length,
            itemBuilder: (context, index) {
              return Card(
                color: widget.checkList.items[index].isAchieved
                    ? Colors.grey.shade200
                    : Colors.white,
                child: CheckboxListTile(
                  value: isAchieved[index],
                  onChanged: (bool? value) {
                    if (widget.checkList.items[index].isAchieved) return;
                    setState(() {
                      isAchieved[index] = value!;
                    });
                  },
                  activeColor: widget.checkList.items[index].isAchieved
                      ? Colors.grey
                      : Theme.of(context).colorScheme.secondary,
                  title: Text(widget.checkList.items[index].content,
                      style: Theme.of(context).textTheme.bodyMedium),
                  subtitle: widget.checkList.items[index].achievedTime != null
                      ? Text('達成済み',
                          style: Theme.of(context).textTheme.bodySmall)
                      : null,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              );
            }),
      ),
      actions: [
        Column(
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  minimumSize: const Size(150, 36),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0))),
              child: const Text('キャンセル'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6.0, bottom: 16.0),
              child: LoadingButton(
                  btnController: btnController,
                  onPressed: () async {
                    List<Item> updatedItems =
                        widget.checkList.items.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final Item item = entry.value;
                      return isAchieved[index] && !item.isAchieved
                          ? Item(
                              id: item.id,
                              month: item.month,
                              isAchieved: true,
                              content: item.content,
                              achievedTime: Timestamp.now())
                          : Item(
                              id: item.id,
                              month: item.month,
                              isAchieved: item.isAchieved,
                              content: item.content,
                              achievedTime: item.achievedTime);
                    }).toList();
                    final updateItemsResult =
                        await CheckListFirestore.updateItems(
                            updatedItems, widget.checkList);
                    if (!updateItemsResult) {
                      if (!mounted) return;
                      Navigator.pop(context);
                      if (!mounted) return;
                      final updateErrorSnackBar =
                          ErrorSnackBar(context, title: 'まとめて達成に失敗しました');
                      ScaffoldMessenger.of(context)
                          .showSnackBar(updateErrorSnackBar);
                      return;
                    }
                    await ChangeButton.showSuccessFor1Seconds(btnController);
                    if (!mounted) return;
                    Navigator.pop(context);
                    var randomInt = FunctionUtils.generateRandomInt(2);
                    if (randomInt == 0) {
                      rewardedInterstitialAdManager.showAd();
                    }
                  },
                  color: Theme.of(context).colorScheme.secondary,
                  child: const Text('達成')),
            ),
          ],
        ),
      ],
    );
  }
}
