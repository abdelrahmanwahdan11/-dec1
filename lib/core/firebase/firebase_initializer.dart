import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../firebase_options.dart';
import 'notification_service.dart';

/// Initializes Firebase and exposes common instances.
class FirebaseInitializer {
  FirebaseInitializer._();

  static bool _initialized = false;

  /// Call once at app startup to configure Firebase services.
  static Future<void> initializeFirebase() async {
    if (_initialized) return;
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _initialized = true;

      if (!kIsWeb) {
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
      }

      await NotificationService.instance.initializeNotifications();
      FirebaseMessaging.onBackgroundMessage(
        NotificationService.firebaseMessagingBackgroundHandler,
      );
      await FirebaseAnalytics.instance.logEvent(name: 'app_start');
    } catch (e, stack) {
      debugPrint('Firebase init failed: $e');
      if (!kIsWeb) {
        await FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
      }
      rethrow;
    }
  }

  /// Shortcut to access [FirebaseAuth].
  static FirebaseAuth get auth => FirebaseAuth.instance;

  /// Shortcut to access [FirebaseFirestore].
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;

  /// Shortcut to access [FirebaseStorage].
  static FirebaseStorage get storage => FirebaseStorage.instance;
}
