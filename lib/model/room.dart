import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  String id;
  String childName;
  Timestamp birthdate;
  List<dynamic> registeredEmailAddresses;
  String? imagePath;

  Room({
    required this.id,
    required this.childName,
    required this.birthdate,
    required this.registeredEmailAddresses,
    this.imagePath
  });
}
