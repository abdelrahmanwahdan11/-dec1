import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_notifications.dart';
import '../models/app_notification.dart';

class NotificationsController extends ChangeNotifier {
  NotificationsController() {
    _load();
  }

  final ValueNotifier<List<AppNotification>> notifications =
      ValueNotifier<List<AppNotification>>(mockNotifications);
  final Set<String> _readIds = {};
  late SharedPreferences _prefs;
  bool _ready = false;

  Future<void> _load() async {
    _prefs = await SharedPreferences.getInstance();
    _ready = true;
    final read = _prefs.getStringList('notification_read_ids') ?? [];
    _readIds
      ..clear()
      ..addAll(read);
    _hydrate();
  }

  void _hydrate() {
    notifications.value = mockNotifications
        .map((n) => n.copyWith(read: _readIds.contains(n.id)))
        .toList();
  }

  Future<void> markRead(String id) async {
    if (!_ready) {
      await _load();
    }
    _readIds.add(id);
    await _prefs.setStringList('notification_read_ids', _readIds.toList());
    _hydrate();
    notifyListeners();
  }

  Future<void> markAllRead() async {
    if (!_ready) {
      await _load();
    }
    _readIds
      ..clear()
      ..addAll(mockNotifications.map((e) => e.id));
    await _prefs.setStringList('notification_read_ids', _readIds.toList());
    _hydrate();
    notifyListeners();
  }

  Future<void> clearAll() async {
    notifications.value = const [];
    notifyListeners();
  }

  @override
  void dispose() {
    notifications.dispose();
    super.dispose();
  }
}
