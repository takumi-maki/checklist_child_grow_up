import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  String id;
  String childName;
  List<dynamic> registeredEmailAddresses;
  Timestamp createdTime;

  Room({
    required this.id,
    required this.childName,
    required this.registeredEmailAddresses,
    required this.createdTime
  });
}
