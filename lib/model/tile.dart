import 'package:flutter/material.dart';

class Tile {
  String? id;
  Icon leading;
  Text title;
  dynamic onTap;


  Tile({
    this.id,
    required this.leading,
    required this.title,
    required this.onTap
  });
}