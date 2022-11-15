import 'package:checklist_child_grow_up/utils/firestore/authentications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/check_list.dart';
import '../../model/comment.dart';
import '../../utils/widget_utils.dart';
import 'achievement_button_widget.dart';
import 'achieved_time_widget.dart';
import 'comment_detail_widget.dart';
import 'text_input_widget.dart';

class ItemDetailPage extends StatefulWidget {
  final CheckList checkList;
  final Item item;
  final List<Comment>? comments;
  const ItemDetailPage({Key? key, required this.checkList, required this.item, required this.comments}) : super(key: key);

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  User currentFirebaseUser = AuthenticationFirestore.currentFirebaseUser!;
  ScrollController scrollController = ScrollController();
  late String itemImagePath;

  @override
  void initState() {
    super.initState();
    itemImagePath = getItemImagePath();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  String getItemImagePath() {
    final CheckListType checkListType = intToCheckListType(widget.checkList.type);
    final Map<dynamic, dynamic> result = CheckList.tabBarList.firstWhere((tabBar) {
      return tabBar['type'] == checkListType;
    }, orElse: () => {'imagePath': 'assets/images/hiyoko_dance.png'});
    return result['imagePath'];
  }

  Timestamp? getPrevCommentCreatedTime(int index) =>
    index > 0 ? widget.comments![index - 1].createdTime : null;

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
                          child: Text(widget.item.content,
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        widget.item.achievedTime == null
                          ? const SizedBox()
                          : AchievedTimeWidget(checkList: widget.checkList, item: widget.item),
                        AchievementButtonWidget(checkList: widget.checkList, item: widget.item),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                            child: Divider()
                        ),
                        Expanded(
                          child: widget.comments == null
                            ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Text('コメントはまだありません')
                            )
                            : ListView.builder(
                              controller: scrollController,
                              itemCount: widget.comments!.length,
                              itemBuilder: (context, index) {
                                final Timestamp? prevCommentCreatedTime = getPrevCommentCreatedTime(index);
                                return CommentDetailWidget(
                                  roomId: widget.checkList.roomId,
                                  checkListId: widget.checkList.id,
                                  comment: widget.comments![index],
                                  prevCommentCreatedTime: prevCommentCreatedTime,
                                  isMine: widget.comments![index].postedAccountId == currentFirebaseUser.uid
                                );
                              }
                            )
                        )
                      ],
                    ),
                  ),
                ),
              ),
              TextInputWidget(
                item: widget.item,
                checkList: widget.checkList,
                scrollController: scrollController,
              )
            ],
          ),
        ),
      ),
    );
  }
}
