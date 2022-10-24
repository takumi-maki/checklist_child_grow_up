import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/model/account.dart';
import 'package:flutter/material.dart';

import '../../model/check_list.dart';
import '../../model/comment.dart';
import '../../utils/firestore/authentications.dart';
import '../../utils/firestore/comments.dart';
import '../../utils/loading/loading_icon_button.dart';
import '../../utils/widget_utils.dart';

class TextInputWidget extends StatefulWidget {
  final Item item;
  final CheckList checkList;
  const TextInputWidget({Key? key, required this.item, required this.checkList}) : super(key: key);

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  TextEditingController commentController = TextEditingController();
  Account myAccount = AuthenticationFirestore.myAccount!;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 70,
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(48),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    minLines: 1,
                    maxLines: 2,
                    controller: commentController,
                    decoration: const InputDecoration(
                        hintText: 'コメントを入力',
                        border: InputBorder.none
                    ),
                  ),
                ),
              )
          ),
          LoadingIconButton(
              onPressed: () async {
                if (commentController.text.isNotEmpty) {
                  Comment newComment = Comment(
                      text: commentController.text,
                      itemId: widget.item.id,
                      postAccountId: myAccount.id,
                      createdTime: Timestamp.now()
                  );
                  var commentAddResult = await CommentFireStore.addComment(widget.checkList, newComment, widget.item.hasComment);
                  if (!commentAddResult) {
                    if(!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                        WidgetUtils.errorSnackBar('コメントの送信に失敗しました')
                    );
                  }
                  commentController.clear();
                  if(!mounted) return;
                  FocusScope.of(context).unfocus();
                }
              },
              icon: const Icon(Icons.send),
              iconSize: 28,
              color: Colors.black54
          ),
        ],
      ),
    );
  }
}
