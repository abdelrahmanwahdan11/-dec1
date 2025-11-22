import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Handles FCM + local notifications (خدمة الإشعارات).
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// Background handler required for FCM when app is terminated/background.
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    debugPrint('BG message: ${message.messageId}');
  }

  /// Request permissions, configure channels, and wire foreground listeners.
  /// Example from a widget's initState:
  /// ```dart
  /// @override
  /// void initState() {
  ///   super.initState();
  ///   NotificationService.instance.initializeNotifications();
  /// }
  /// ```
  Future<void> initializeNotifications() async {
    if (_initialized) return;
    _initialized = true;
    if (!kIsWeb) {
      final settings = await _messaging.requestPermission();
      debugPrint('Notification permission: ${settings.authorizationStatus}');
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );
    await _local.initialize(initSettings);

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    listenToForegroundMessages();
  }

  /// Get FCM token for this device (يُحفظ عادة مع المستخدم في Firestore).
  Future<String?> getFcmToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      debugPrint('Fetching FCM token failed: $e');
      return null;
    }
  }

  /// Show local notification from a [RemoteMessage].
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'plants_fresher_channel',
      'Plants Fresher Alerts',
      channelDescription: 'General notifications for Plants Fresher',
      importance: Importance.max,
      priority: Priority.high,
    );
    const darwinDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: darwinDetails, macOS: darwinDetails);

    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      message.notification?.title ?? 'New update',
      message.notification?.body ?? 'You have a new message',
      details,
    );
  }

  /// Listen to foreground messages and surface them as local notifications.
  void listenToForegroundMessages() {
    FirebaseMessaging.onMessage.listen((message) {
      _showLocalNotification(message);
    });
  }

  /// Handle user tapping notifications while app is in background.
  void handleMessageOpenedApp(void Function(RemoteMessage message) handler) {
    FirebaseMessaging.onMessageOpenedApp.listen(handler);
  }
}
