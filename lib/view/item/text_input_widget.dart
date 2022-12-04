import 'dart:io';

import 'package:checklist_child_grow_up/utils/firebase_storage/images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../model/check_list.dart';
import '../../model/comment.dart';
import '../../utils/firestore/authentications.dart';
import '../../utils/firestore/comments.dart';
import '../../utils/loading/loading_icon_button.dart';
import '../../utils/widget_utils.dart';

class TextInputWidget extends StatefulWidget {
  final Item item;
  final CheckList checkList;
  final ScrollController scrollController;
  const TextInputWidget({
    Key? key,
    required this.item,
    required this.checkList,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  TextEditingController commentController = TextEditingController();
  final User currentFirebaseUser = AuthenticationFirestore.currentFirebaseUser!;
  var uuid = const Uuid();
  File? compressedImage;
  String? imagePath;

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          compressedImage == null
            ? const SizedBox()
            : Stack(
              alignment: Alignment.topRight,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.file(
                      compressedImage!,
                      height: 200,
                    )
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: CircleAvatar(
                    maxRadius: 10.0,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    child: IconButton(
                      padding: const EdgeInsets.all(1.0),
                      iconSize: 14.0,
                      icon: const Icon(Icons.close),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          compressedImage = null;
                        });
                      },
                      splashRadius: 0.1,
                    ),
                  ),
                )
              ]
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                    var image = await ImageFirebaseStorage.selectImage();
                    compressedImage = await ImageFirebaseStorage.compressImage(image);
                    setState((){});
                  },
                  icon: const Icon(Icons.image),
                  iconSize: 28.0,
                  color: Colors.black54
                ),
                LoadingIconButton(
                  onPressed: () async {
                    if (commentController.text.isEmpty && compressedImage == null) return;
                    if (compressedImage != null) {
                      TaskSnapshot? uploadImageTaskSnapshot = await ImageFirebaseStorage.uploadImage(compressedImage!);
                      if (uploadImageTaskSnapshot == null) {
                        if(!mounted) return;
                        WidgetUtils.errorSnackBar(context, '画像の送信に失敗しました');
                        return;
                      }
                      imagePath = await uploadImageTaskSnapshot.ref.getDownloadURL();
                    }
                    Comment newComment = Comment(
                      id: uuid.v4(),
                      text: commentController.text.isEmpty ? null : commentController.text,
                      imagePath: imagePath,
                      itemId: widget.item.id,
                      postedAccountId: currentFirebaseUser.uid,
                      readAccountIds: [currentFirebaseUser.uid],
                      createdTime: Timestamp.now()
                    );
                    var commentAddResult = await CommentFireStore.addComment(widget.checkList, newComment);
                    if (!commentAddResult) {
                      if(!mounted) return;
                      WidgetUtils.errorSnackBar(context, 'コメントの送信に失敗しました');
                      return;
                    }
                    compressedImage = null;
                    imagePath = null;
                    setState(() {});
                    commentController.clear();
                    if(!mounted) return;
                    FocusScope.of(context).unfocus();
                    widget.scrollController.animateTo(
                      widget.scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 1),
                      curve: Curves.linear
                    );
                  },
                  icon: const Icon(Icons.send),
                  iconSize: 28,
                  color: Colors.black54
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
