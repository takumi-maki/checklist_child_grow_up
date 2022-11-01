import 'dart:typed_data';

import 'package:checklist_child_grow_up/utils/function_utils.dart';
import 'package:checklist_child_grow_up/utils/loading/loading_gesture_detector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/comment.dart';

class MyCommentWidget extends StatefulWidget {
  final Comment comment;
  final  Timestamp? prevCommentCreatedTime;
  const MyCommentWidget({
    Key? key,
    required this.comment,
    required this.prevCommentCreatedTime
  }) : super(key: key);

  @override
  State<MyCommentWidget> createState() => _MyCommentWidgetState();
}

class _MyCommentWidgetState extends State<MyCommentWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FunctionUtils.shouldHideCommentDate(
                widget.comment.createdTime.toDate(),
                widget.prevCommentCreatedTime?.toDate()
              )
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
                  Uint8List image =  await FunctionUtils.convertImagePathToUint8List(widget.comment.imagePath!);
                  if (!mounted) return;
                  return FunctionUtils.showPreviewImage(context, image);
                },
                child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.50
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(widget.comment.imagePath!)
                    ),
                ),
              ),
            ),
          widget.comment.text == null
            ? const SizedBox()
            : Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80
              ),
              padding: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                  bottomLeft: Radius.circular(12.0),
                ),
              ),
              child: Text(widget.comment.text!, style: const TextStyle(color: Colors.white)),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(widget.comment.postAccountName ?? ''),
            ],
          ),
        ],
      ),
    );
  }
}
