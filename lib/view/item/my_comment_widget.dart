import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/comment.dart';

class MyCommentWidget extends StatefulWidget {
  final Comment comment;
  const MyCommentWidget({Key? key, required this.comment}) : super(key: key);

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
          widget.comment.imagePath == null
            ? const SizedBox()
            : Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.50
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(widget.comment.imagePath!)
                ),
            ),
          const SizedBox(height: 8.0),
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
          const SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(DateFormat('yyyy/MM/dd').format(widget.comment.createdTime.toDate())),
              const SizedBox(width: 10.0),
              Text(widget.comment.postAccountName ?? ''),
            ],
          ),
        ],
      ),
    );
  }
}
