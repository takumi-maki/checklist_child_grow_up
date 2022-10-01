import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checklist_child_grow_up/model/account.dart';
import 'package:flutter/material.dart';

import '../../model/check_list.dart';
import '../../model/comment.dart';
import '../../utils/firestore/authentications.dart';
import '../../utils/firestore/check_lists.dart';
import '../../utils/firestore/comments.dart';
import '../../utils/loading/loading_icon_button.dart';

class TextInputWidget extends StatefulWidget {
  final TextEditingController commentController;
  final Item item;
  final CheckList checkList;
  const TextInputWidget({
    Key? key,
    required this.commentController,
    required this.item,
    required this.checkList
  }) : super(key: key);

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
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
                    controller: widget.commentController,
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
                if (widget.commentController.text.isNotEmpty) {
                  Comment newComment = Comment(
                      text: widget.commentController.text,
                      itemId: widget.item.id,
                      postAccountId: myAccount.id,
                      createdTime: Timestamp.now()
                  );
                  var commentAdd = await CommentFireStore.addComment(widget.checkList, newComment);
                  if (commentAdd) {
                    Item updateItem = Item(
                        id: widget.item.id,
                        month: widget.item.month,
                        isComplete: widget.item.isComplete,
                        content: widget.item.content,
                        hasComment: true,
                        completedTime: widget.item.completedTime
                    );
                    var itemUpdated = await CheckListFirestore.updateItem(updateItem, widget.checkList);
                    if (itemUpdated) {
                      widget.commentController.clear();
                      if(!mounted) return;
                      FocusScope.of(context).unfocus();
                    }
                  }
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
