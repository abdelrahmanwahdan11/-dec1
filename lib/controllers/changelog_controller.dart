import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_updates.dart';
import '../models/update_note.dart';

class ChangelogController {
  static const _key = 'last_seen_update_version';
  final ValueNotifier<List<UpdateNote>> updates =
      ValueNotifier([...mockUpdates]..sort((a, b) => b.date.compareTo(a.date)));
  final ValueNotifier<DateTime?> lastSeenDate = ValueNotifier(null);

  ChangelogController() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getString(_key);
    if (seen != null) {
      lastSeenDate.value = DateTime.tryParse(seen);
    }
  }

  bool get hasUnread {
    final seen = lastSeenDate.value;
    return updates.value.any((u) => seen == null || u.date.isAfter(seen));
  }

  Future<void> markAllSeen() async {
    if (updates.value.isEmpty) return;
    final newest = updates.value.first.date;
    lastSeenDate.value = newest;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, newest.toIso8601String());
  }

  void dispose() {
    updates.dispose();
    lastSeenDate.dispose();
  }
}
