import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class ImageFirebaseStorage {
  static final ImagePicker picker = ImagePicker();

  static Future<File?> selectImage() async {
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return null;
    debugPrint('画像選択完了');
    return File(pickedImage.path);
  }
  static Future compressImage(File? image) async {
    if (image == null) return null;
    String targetPath = image.absolute.path.replaceAll('.jpg', '_compressed.jpg');
    return await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      targetPath,
      quality: 70
    );
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
  static Future<void> deleteImage(String imagePath) async {
    try {
      final storageReference = FirebaseStorage.instance.refFromURL(imagePath);
      await storageReference.delete();
      debugPrint('画像削除完了');
    } on FirebaseException catch (e) {
      debugPrint('画像削除エラー: $e');
    }
  }
}