import 'package:flutter/material.dart';

import '../../model/account.dart';

class CommentAccountDetailWidget extends StatelessWidget {
  const CommentAccountDetailWidget({Key? key, this.account, required this.isMine}) : super(key: key);

  final Account? account;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        isMine
          ? Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: account != null ? Text(account!.name) : const Text('unknown'),
          )
          : const SizedBox(),
        account != null && account!.imagePath != null
          ? CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            backgroundImage: NetworkImage(account!.imagePath!)
          )
          : CircleAvatar(
            backgroundColor: Colors.orange.shade200,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset('assets/images/chicken.png'),
            ),
          ),
        isMine
          ? const SizedBox()
          : Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: account != null ? Text(account!.name) : const Text('unknown'),
          )
      ],
    );
  }
}
