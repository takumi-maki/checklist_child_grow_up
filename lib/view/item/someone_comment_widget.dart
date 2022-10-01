import 'package:checklist_child_grow_up/model/account.dart';
import 'package:checklist_child_grow_up/model/comment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SomeOneCommentWidget extends StatefulWidget {
  final Comment comment;
  final Account postAccount;
  const SomeOneCommentWidget({Key? key, required this.comment, required this.postAccount}) : super(key: key);

  @override
  State<SomeOneCommentWidget> createState() => _SomeOneCommentWidgetState();
}

class _SomeOneCommentWidgetState extends State<SomeOneCommentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80
            ),
            padding: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Text(widget.comment.text, style: const TextStyle(color: Colors.black54)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            child: Text(DateFormat('yyyy/MM/dd').format(widget.comment.createdTime.toDate())),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(widget.postAccount.name),
          ),
        ],
      ),
    );
  }
}
