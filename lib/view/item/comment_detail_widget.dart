import 'dart:typed_data';

import 'package:checklist_child_grow_up/utils/firestore/accounts.dart';
import 'package:checklist_child_grow_up/utils/firestore/comments.dart';
import 'package:checklist_child_grow_up/utils/loading/loading_gesture_detector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../model/comment.dart';
import '../../utils/firestore/authentications.dart';
import '../../utils/widget_utils.dart';
import 'image_preview_screen.dart';

class CommentDetailWidget extends StatefulWidget {
  final String roomId;
  final String checkListId;
  final Comment comment;
  final Timestamp? prevCommentCreatedTime;
  final bool isMine;
  const CommentDetailWidget({
    Key? key,
    required this.roomId,
    required this.checkListId,
    required this.comment,
    required this.prevCommentCreatedTime,
    required this.isMine
  }) : super(key: key);

  @override
  State<CommentDetailWidget> createState() => _CommentDetailWidgetState();
}

class _CommentDetailWidgetState extends State<CommentDetailWidget> {
  late User currentFirebaseUser;

  @override
  void initState() {
    super.initState();
    currentFirebaseUser = AuthenticationFirestore.currentFirebaseUser!;
    if (!widget.isMine && !widget.comment.readAccountIds.contains(currentFirebaseUser.uid)) {
      Future(() async {
        await updateReadAccountIds();
      });
    }
  }
  Future<void> updateReadAccountIds() async {
    List updatedReadAccountIds;
    updatedReadAccountIds = widget.comment.readAccountIds;
    updatedReadAccountIds.add(currentFirebaseUser.uid);
    final updatedComment = Comment(
      id: widget.comment.id,
      text: widget.comment.text,
      imagePath: widget.comment.imagePath,
      itemId: widget.comment.itemId,
      postedAccountId: widget.comment.postedAccountId,
      readAccountIds: updatedReadAccountIds,
      createdTime: widget.comment.createdTime
    );
    var updateCommentResult = await CommentFireStore.updateComment(
      widget.roomId,
      widget.checkListId,
      updatedComment
    );
    if (!updateCommentResult) {
      if (!mounted) return;
      WidgetUtils.errorSnackBar(context, '既読機能の更新に失敗しました');
      return;
    }
  }
  bool shouldHideCommentDate() {
    if(widget.prevCommentCreatedTime == null) return false;
    final thisCommentCreatedAt = widget.comment.createdTime.toDate();
    final prevCommentCreatedAt = widget.prevCommentCreatedTime!.toDate();
    return thisCommentCreatedAt.difference(prevCommentCreatedAt).inDays == 0
        && thisCommentCreatedAt.day == prevCommentCreatedAt.day;
  }
  Future<Uint8List> convertImagePathToUint8List(String imagePath) async {
    return (await NetworkAssetBundle(Uri.parse(imagePath)).load(imagePath)).buffer.asUint8List();
  }
  void showPreviewImage(Uint8List image) {
    showDialog(context: context, builder: (context) {
      return ImagePreviewScreen(image: image);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: widget.isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              shouldHideCommentDate()
                ? const SizedBox()
                : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(48),
                    ),
                    child: Text(DateFormat('yyyy/MM/dd').format(widget.comment.createdTime.toDate()))
                  ),
                )
            ],
          ),
          widget.comment.imagePath == null
            ? const SizedBox()
            : Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: LoadingGestureDetector(
                onTap: () async {
                  Uint8List image =  await convertImagePathToUint8List(widget.comment.imagePath!);
                  if (!mounted) return;
                  return showPreviewImage(image);
                },
                child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.50,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        widget.comment.imagePath!,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.50,
                            height: MediaQuery.of(context).size.width * 0.40,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Center(
                              child: SizedBox(
                                height: 20.0,
                                width: 20.0,
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                    : null,
                                  valueColor: const AlwaysStoppedAnimation(Colors.amber),
                                ),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (BuildContext context, Object object, StackTrace? stackTrace) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.50,
                            height: MediaQuery.of(context).size.width * 0.40,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.error_outline),
                                  Text('画像の取得に失敗しました', style: Theme.of(context).textTheme.bodySmall)
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    ),
                ),
              ),
            ),
          widget.comment.text == null
            ? const SizedBox()
            : Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.80
                ),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: widget.isMine ? null : Border.all(width: 0.1),
                  color: widget.isMine ? Colors.black54 : Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(12.0),
                      topRight: const Radius.circular(12.0),
                      bottomLeft: widget.isMine ? const Radius.circular(12.0) : Radius.zero,
                      bottomRight: widget.isMine ? Radius.zero : const Radius.circular(12.0),
                      )
                ),
                child: Text(widget.comment.text!, style: TextStyle(color: widget.isMine ? Colors.white : Colors.black87)),
              ),
            ),
          StreamBuilder<QuerySnapshot>(
            stream: AccountFirestore.accounts
              .where('id', isEqualTo: widget.comment.postedAccountId).snapshots(),
            builder: (context, accountSnapshot) {
              if (!accountSnapshot.hasData  || accountSnapshot.data!.docs.isEmpty) {
                return Row(
                  mainAxisAlignment: widget.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: const [
                    Text('unknown'),
                  ],
                );
              }
              Map<String, dynamic> account = accountSnapshot.data!.docs.first.data() as Map<String, dynamic>;
              return Row(
                mainAxisAlignment: widget.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Text(account['name']),
                ],
              );
            }
          ),
        ],
      ),
    );
  }
}
