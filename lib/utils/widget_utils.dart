import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WidgetUtils {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> errorSnackBar(BuildContext context, String title) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(title),
        backgroundColor: Theme.of(context).errorColor
      )
    );
  }

  static circularProgressIndicator({
    double height = 20.0,
    double width = 20.0,
    Color color = Colors.amber
  }) {
    return SizedBox(
      height: height,
      width: width,
      child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }
}