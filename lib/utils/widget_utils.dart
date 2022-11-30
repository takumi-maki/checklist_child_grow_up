import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WidgetUtils {
  static AppBar createAppBar(BuildContext context, String title) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black87),
      title: Text(title, style: Theme.of(context).textTheme.subtitle1),
      centerTitle: true, systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }
  static AppBar createModalBottomSheetAppBar(BuildContext context, String title) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      iconTheme: const IconThemeData(color: Colors.black87),
      title: Text(title, style: Theme.of(context).textTheme.subtitle1),
      actions: [
        IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close)
        )
      ],
    );
  }
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> errorSnackBar(BuildContext context, String title) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(title),
        backgroundColor: Theme.of(context).errorColor
      )
    );
  }
}