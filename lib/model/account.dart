import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  String id;
  String name;
  Timestamp createdTime;

  Account({
    required this.id,
    required this.name,
    required this.createdTime,
  });
}