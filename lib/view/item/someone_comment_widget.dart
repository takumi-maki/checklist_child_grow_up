import 'package:checklist_child_grow_up/model/comment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SomeOneCommentWidget extends StatefulWidget {
  final Comment comment;
  const SomeOneCommentWidget({Key? key, required this.comment}) : super(key: key);

  @override
  State<SomeOneCommentWidget> createState() => _SomeOneCommentWidgetState();
}

class _SomeOneCommentWidgetState extends State<SomeOneCommentWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                decoration: BoxDecoration(
                  border: Border.all(width: 0.1),
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0),
                  ),
                ),
                child: Text(widget.comment.text!, style: const TextStyle(color: Colors.black87)),
            ),
          const SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
