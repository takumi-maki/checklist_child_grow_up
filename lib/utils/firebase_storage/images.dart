import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageFirebaseStorage {
  static final ImagePicker picker = ImagePicker();

  static Future<File?> selectImage() async {
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return null;
    return File(pickedImage.path);
  }
  static Future<TaskSnapshot?> uploadImage(File image) async {
    String path = image.path.substring(image.path.lastIndexOf('/') + 1);
    final ref = FirebaseStorage.instance.ref(path);
    try {
      final taskSnapshot = await ref.putFile(image);
      debugPrint('画像アップロード完了');
      return taskSnapshot;
    } on FirebaseException catch (e) {
      debugPrint('画像アップロードエラー: $e');
      return null;
    }
  }
}