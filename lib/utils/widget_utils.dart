import 'package:flutter/material.dart';

class WidgetUtils {
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