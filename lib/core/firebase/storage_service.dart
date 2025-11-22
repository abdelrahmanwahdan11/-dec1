import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

/// Simple Cloud Storage helper (رفع/قراءة/حذف ملفات مثل الصور والفيديو).
class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload a local file and return the download URL.
  /// استخدام شائع: `final url = await uploadFile(File(path), 'uploads/user123.jpg');`
  Future<String> uploadFile(File file, String path) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Storage uploadFile failed: $e');
      rethrow;
    }
  }

  /// Upload raw bytes (مفيد للويب أو عندما تكون الصورة في الذاكرة).
  Future<String> uploadBytes(Uint8List bytes, String path) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = await ref.putData(bytes);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Storage uploadBytes failed: $e');
      rethrow;
    }
  }

  /// Delete a file from Cloud Storage.
  Future<void> deleteFile(String path) async {
    try {
      await _storage.ref().child(path).delete();
    } catch (e) {
      debugPrint('Storage delete failed: $e');
      rethrow;
    }
  }
}
