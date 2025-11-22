import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_events.dart';
import '../models/plant_event.dart';

class EventsController extends ChangeNotifier {
  static const _rsvpKey = 'event_rsvps';
  static const _bookmarkKey = 'event_bookmarks';

  final ValueNotifier<List<PlantEvent>> events = ValueNotifier(mockEvents);
  final ValueNotifier<Set<String>> rsvps = ValueNotifier({});
  final ValueNotifier<Set<String>> bookmarks = ValueNotifier({});

  EventsController() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    rsvps.value = (prefs.getStringList(_rsvpKey) ?? []).toSet();
    bookmarks.value = (prefs.getStringList(_bookmarkKey) ?? []).toSet();
  }

  bool isRsvped(String id) => rsvps.value.contains(id);

  bool isBookmarked(String id) => bookmarks.value.contains(id);

  Future<void> toggleRsvp(String id) async {
    final updated = <String>{...rsvps.value};
    if (!updated.add(id)) {
      updated.remove(id);
    }
    rsvps.value = updated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_rsvpKey, updated.toList());
  }

  Future<void> toggleBookmark(String id) async {
    final updated = <String>{...bookmarks.value};
    if (!updated.add(id)) {
      updated.remove(id);
    }
    bookmarks.value = updated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_bookmarkKey, updated.toList());
  }

  List<PlantEvent> upcomingOnly() {
    final now = DateTime.now();
    return events.value.where((e) => e.date.isAfter(now)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<PlantEvent> workshopsOnly() =>
      upcomingOnly().where((e) => e.isWorkshop).toList();

  @override
  void dispose() {
    events.dispose();
    rsvps.dispose();
    bookmarks.dispose();
    super.dispose();
  }
}
