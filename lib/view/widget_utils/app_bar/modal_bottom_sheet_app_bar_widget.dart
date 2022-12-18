import 'package:flutter/material.dart';

class ModalBottomSheetAppBarWidget extends StatelessWidget with PreferredSizeWidget {
  const ModalBottomSheetAppBarWidget({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      iconTheme: const IconThemeData(color: Colors.black87),
      title: Text(title, style: Theme.of(context).textTheme.subtitle1),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close)
        )
      ],
    );
  }
}
