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
  static SnackBar errorSnackBar(String title) {
    return SnackBar(
        backgroundColor: Colors.red,
        content: Text(title)
    );
  }
}