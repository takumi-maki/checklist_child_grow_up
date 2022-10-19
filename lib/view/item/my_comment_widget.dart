import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/account.dart';
import '../../model/comment.dart';

class MyCommentWidget extends StatefulWidget {
  final Comment comment;
  final Account postAccount;
  const MyCommentWidget({Key? key, required this.comment, required this.postAccount}) : super(key: key);

  @override
  State<MyCommentWidget> createState() => _MyCommentWidgetState();
}

class _MyCommentWidgetState extends State<MyCommentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80
            ),
            padding: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: Text(widget.comment.text, style: const TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(DateFormat('yyyy/MM/dd').format(widget.comment.createdTime.toDate())),
              const SizedBox(width: 10.0),
              Text(widget.postAccount.name),
            ],
          ),
        ],
      ),
    );
  }
}
