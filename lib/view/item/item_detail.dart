import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_sns_app/model/comment.dart';
import 'package:demo_sns_app/utils/firestore/authentications.dart';
import 'package:demo_sns_app/utils/firestore/check_lists.dart';
import 'package:demo_sns_app/utils/firestore/comments.dart';
import 'package:demo_sns_app/utils/firestore/rooms.dart';
import 'package:demo_sns_app/utils/firestore/users.dart';
import 'package:demo_sns_app/utils/function_utils.dart';
import 'package:demo_sns_app/utils/loading/loading_icon_button.dart';
import 'package:demo_sns_app/utils/widget_utils.dart';
import 'package:demo_sns_app/view/banner/ad_banner.dart';
import 'package:demo_sns_app/view/item/my_comment_widget.dart';
import 'package:demo_sns_app/view/item/someone_comment_widget.dart';
import 'package:demo_sns_app/view/item/text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/account.dart';
import '../../model/check_list.dart';
import '../../utils/loading/loading_elevated_button.dart';

class ItemDetail extends StatefulWidget {
  final CheckList checkList;
  final int itemIndex;
  final Item item;
  const ItemDetail({Key? key, required this.checkList, required this.itemIndex, required this.item}) : super(key: key);

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  TextEditingController commentController = TextEditingController();
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
    return Scaffold(
      appBar: WidgetUtils.createAppBar(''),
      body: SafeArea(
        child: Column(
          children: [
            Center(child: Image.asset(imagePath, height: 80)),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text('「　${widget.item.content}　」',  style: const TextStyle(fontSize: 18, color: Colors.black87))),
            const SizedBox(height: 20),
            LoadingElevatedButton(
                onPressed: () async {
                  !widget.item.isComplete ? await FunctionUtils.congratulationDialog(context) : null;
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
                    if(!mounted) return;
                    Navigator.pop(context);
                  }
                },
                buttonStyle: ElevatedButton.styleFrom(primary: widget.item.isComplete ? Colors.grey : Theme.of(context).colorScheme.secondary),
                child: widget.item.isComplete ? const Text('達成をキャンセル') : const Text('達成')
            ),
            const SizedBox(height: 30),
            const AdBanner(),
            const Divider(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: RoomFirestore.rooms.doc(widget.checkList.roomId)
                  .collection('check_lists').doc(widget.checkList.id)
                  .collection('comments').orderBy('created_time', descending: false).where('item_id', isEqualTo: widget.checkList.items[widget.itemIndex].id)
                  .snapshots(),
                builder: (context, commentSnapshot) {
                  if(commentSnapshot.hasData) {
                    List<String> postAccountIds = [];
                    for (var doc in commentSnapshot.data!.docs) {
                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                    if (!postAccountIds.contains(data['post_account_id'])) {
                      postAccountIds.add(data['post_account_id']);
                     }
                    }
                    return FutureBuilder<Map<String, Account>?>(
                      future: UserFirestore.getPostUserMap(postAccountIds),
                      builder: (context, userSnapshot) {
                        if(userSnapshot.hasData && userSnapshot.connectionState == ConnectionState.done) {
                          if (commentSnapshot.data!.docs.isEmpty) return Container(padding: const EdgeInsets.symmetric(vertical: 20.0), child: const Text('コメントはまだありません'));
                          return ListView.builder(
                              itemCount: commentSnapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> data = commentSnapshot.data!.docs[index].data() as Map<String, dynamic>;
                                Comment comment = Comment(
                                    text: data['text'],
                                    itemId: data['item_id'],
                                    postAccountId: data['post_account_id'],
                                    createdTime: data['created_time']
                                );
                                Account postAccount = userSnapshot.data![comment.postAccountId]!;
                                if (comment.postAccountId == myAccount.id) {
                                  return MyCommentWidget(comment: comment, postAccount: postAccount);
                                } else {
                                  return SomeOneCommentWidget(comment: comment, postAccount: postAccount);
                                }
                              });
                        } else {
                          return Container();
                        }
                      }
                    );
                  } else {
                    return Container();
                  }
                }
              ),
            ),
            TextInputWidget(commentController: commentController, item: widget.item, checkList: widget.checkList)
          ],
        ),
      ),
    );
  }
}