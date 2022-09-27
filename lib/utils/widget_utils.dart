import 'package:flutter/material.dart';

class WidgetUtils {
  static AppBar createAppBar(String title) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black54),
      title: Text(title, style: const TextStyle(color: Colors.black54)),
      centerTitle: true,
    );
  }
  static SnackBar errorSnackBar(String title) {
    return SnackBar(
        backgroundColor: const Color.fromRGBO(255, 102, 102, 1),
        content: Text('$title')
    );
  }
}