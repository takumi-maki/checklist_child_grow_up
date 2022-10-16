import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WidgetUtils {
  static AppBar createAppBar(String title) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black87),
      title: Text(title, style: const TextStyle(color: Colors.black87, fontSize: 16)),
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