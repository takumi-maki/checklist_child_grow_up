import 'package:checklist_child_grow_up/utils/firestore/authentications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/check_list.dart';
import '../../model/comment.dart';
import '../../utils/firestore/rooms.dart';
import '../banner/ad_banner_widget.dart';
import '../widget_utils/app_bar/app_bar_widget.dart';
import '../widget_utils/loading/circular_progress_indicator_widget.dart';
import 'achieved_date_calender_widget.dart';
import 'achievement_button_widget.dart';
import 'comment_detail_widget.dart';
import 'text_input_widget.dart';

class ItemDetailPage extends StatefulWidget {
  const ItemDetailPage({
    Key? key,
    required this.checkList,
    required this.itemId,
    required this.birthDateTime,
  }) : super(key: key);

  final CheckList checkList;
  final String itemId;
  final DateTime birthDateTime;

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
    itemImagePath = getCheckListTypeImagePath(widget.checkList.type);
  }

  double getItemDetailWidgetHeight() {
    double itemDetailWidgetHeight;
    final appBarWidgetHeight = AppBar().preferredSize.height;
    const double textInputWidgetHeight = 66.0;
    const double adBannerWidgetHeight = 64.0;
    itemDetailWidgetHeight = MediaQuery.of(context).size.height -
        appBarWidgetHeight -
        textInputWidgetHeight -
        adBannerWidgetHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    return itemDetailWidgetHeight;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Item getItem(Map<String, dynamic> checkList) {
    List checkListItems = checkList['items'];
    final item = checkListItems.firstWhere((item) {
      return item['id'] == widget.itemId;
    });
    return Item(
        id: item['id'],
        month: item['month'],
        isAchieved: item['is_achieved'],
        content: item['content'],
        achievedTime: item['achieved_time']);
  }

  Timestamp? getPrevCommentCreatedTime(
      int index, List<QueryDocumentSnapshot<Object?>> commentDocs) {
    final Map<String, dynamic>? prevComment = (index > 0
        ? commentDocs[index - 1].data()
        : null) as Map<String, dynamic>?;
    return prevComment != null ? prevComment['created_time'] : null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const AppBarWidget(title: 'アイテム詳細'),
        body: SafeArea(
          child: StreamBuilder<DocumentSnapshot>(
              stream: RoomFirestore.rooms
                  .doc(widget.checkList.roomId)
                  .collection('check_lists')
                  .doc(widget.checkList.id)
                  .snapshots(),
              builder: (context, checkListSnapshot) {
                if (!checkListSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicatorWidget());
                }
                final item = getItem(
                    checkListSnapshot.data!.data() as Map<String, dynamic>);
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: SizedBox(
                          height: getItemDetailWidgetHeight(),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(
                                    child:
                                        Image.asset(itemImagePath, height: 80)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 18.0, top: 10.0, right: 18.0),
                                child: Text(
                                  item.content,
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              item.achievedTime == null
                                  ? const SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: AchievedDateCalenderWidget(
                                          checkList: widget.checkList,
                                          item: item,
                                          birthDateTime: widget.birthDateTime,
                                          achievedDateTime:
                                              item.achievedTime!.toDate()),
                                    ),
                              AchievementButtonWidget(
                                  checkList: widget.checkList, item: item),
                              const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  child: Divider()),
                              Expanded(
                                  child: StreamBuilder<QuerySnapshot>(
                                      stream: RoomFirestore.rooms
                                          .doc(widget.checkList.roomId)
                                          .collection('check_lists')
                                          .doc(widget.checkList.id)
                                          .collection('comments')
                                          .orderBy('created_time',
                                              descending: false)
                                          .where('item_id', isEqualTo: item.id)
                                          .snapshots(),
                                      builder: (context, commentSnapshot) {
                                        if (!commentSnapshot.hasData) {
                                          return const CircularProgressIndicatorWidget();
                                        }
                                        List<QueryDocumentSnapshot<Object?>>
                                            commentDocs =
                                            commentSnapshot.data!.docs;
                                        if (commentDocs.isEmpty) {
                                          return const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 20.0),
                                              child: Text('コメントはまだありません'));
                                        }
                                        return ListView.builder(
                                            controller: scrollController,
                                            itemCount: commentDocs.length,
                                            itemBuilder: (context, index) {
                                              Timestamp?
                                                  prevCommentCreatedTime =
                                                  getPrevCommentCreatedTime(
                                                      index, commentDocs);
                                              Map<String, dynamic> data =
                                                  commentDocs[index].data()
                                                      as Map<String, dynamic>;
                                              Comment comment = Comment(
                                                  id: data['id'],
                                                  text: data['text'],
                                                  imagePath: data['image_path'],
                                                  itemId: data['item_id'],
                                                  postedAccountId:
                                                      data['posted_account_id'],
                                                  readAccountIds:
                                                      data['read_account_ids'],
                                                  createdTime:
                                                      data['created_time']);
                                              return CommentDetailWidget(
                                                  roomId:
                                                      widget.checkList.roomId,
                                                  checkListId:
                                                      widget.checkList.id,
                                                  comment: comment,
                                                  prevCommentCreatedTime:
                                                      prevCommentCreatedTime,
                                                  isMine: comment
                                                          .postedAccountId ==
                                                      currentFirebaseUser.uid);
                                            });
                                      }))
                            ],
                          ),
                        ),
                      ),
                    ),
                    TextInputWidget(
                      item: item,
                      checkList: widget.checkList,
                      scrollController: scrollController,
                    )
                  ],
                );
              }),
        ),
        bottomNavigationBar: const AdBannerWidget(),
      ),
    );
  }
}
