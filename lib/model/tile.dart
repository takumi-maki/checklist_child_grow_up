import 'package:flutter/material.dart';

class Tile {
  String? id;
  Icon leading;
  Text title;
  bool isErrorText;
  VoidCallback onTap;

  Tile({
    this.id,
    required this.leading,
    required this.title,
    this.isErrorText = false,
    required this.onTap,
  });
}