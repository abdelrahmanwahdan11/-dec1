import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Generic Firestore CRUD helper (مساعد موحد لإضافة/تعديل/حذف/الاستماع).
class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Add a document to [collectionPath]. Returns the new [DocumentReference].
  /// مثال استخدام داخل Widget:
  /// ```dart
  /// await FirestoreService.instance.addDocument('plants', {'name': 'Aloe', 'price': 20});
  /// ```
  Future<DocumentReference<Map<String, dynamic>>> addDocument(
    String collectionPath,
    Map<String, dynamic> data,
  ) async {
    try {
      return await _db.collection(collectionPath).add(data);
    } catch (e) {
      debugPrint('Firestore add failed: $e');
      rethrow;
    }
  }

  /// Set (create or merge) a document by id.
  Future<void> setDocument(
    String collectionPath,
    String docId,
    Map<String, dynamic> data, {
    bool merge = true,
  }) async {
    try {
      await _db.collection(collectionPath).doc(docId).set(data, SetOptions(merge: merge));
    } catch (e) {
      debugPrint('Firestore set failed: $e');
      rethrow;
    }
  }

  /// Update an existing document.
  Future<void> updateDocument(
    String collectionPath,
    String docId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _db.collection(collectionPath).doc(docId).update(data);
    } catch (e) {
      debugPrint('Firestore update failed: $e');
      rethrow;
    }
  }

  /// Delete a document by id.
  Future<void> deleteDocument(String collectionPath, String docId) async {
    try {
      await _db.collection(collectionPath).doc(docId).delete();
    } catch (e) {
      debugPrint('Firestore delete failed: $e');
      rethrow;
    }
  }

  /// Listen to a collection with optional query builder (مثال تصفية حسب category).
  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection(
    String collectionPath, {
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)? queryBuilder,
  }) {
    Query<Map<String, dynamic>> query = _db.collection(collectionPath);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    return query.snapshots();
  }

  /// Listen to a single document in real time.
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamDocument(
    String collectionPath,
    String docId,
  ) {
    return _db.collection(collectionPath).doc(docId).snapshots();
  }

  /// Read a single document once (إحضار فوري بدون Stream).
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(
    String collectionPath,
    String docId,
  ) async {
    try {
      return await _db.collection(collectionPath).doc(docId).get();
    } catch (e) {
      debugPrint('Firestore get failed: $e');
      rethrow;
    }
  }
}
