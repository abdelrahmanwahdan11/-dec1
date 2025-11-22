import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_journal_entries.dart';
import '../models/journal_entry.dart';

class JournalController {
  static const _key = 'journal_entries';
  final ValueNotifier<List<JournalEntry>> entries = ValueNotifier(mockJournalEntries);

  JournalController() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_key);
    if (stored != null && stored.isNotEmpty) {
      final parsed = stored.map(JournalEntry.fromJson).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      entries.value = parsed;
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, entries.value.map((e) => e.toJson()).toList());
  }

  Future<void> addEntry({
    required String titleEn,
    required String titleAr,
    required String noteEn,
    required String noteAr,
    required String imageUrl,
    String mood = 'calm',
  }) async {
    final entry = JournalEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titleEn: titleEn,
      titleAr: titleAr,
      noteEn: noteEn,
      noteAr: noteAr,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
      mood: mood,
    );
    entries.value = [entry, ...entries.value];
    await _save();
  }

  Future<void> toggleFavorite(String id) async {
    entries.value = entries.value
        .map((e) => e.id == id ? e.copyWith(favorite: !e.favorite) : e)
        .toList();
    await _save();
  }

  Future<void> removeEntry(String id) async {
    entries.value = entries.value.where((e) => e.id != id).toList();
    await _save();
  }

  void dispose() {
    entries.dispose();
  }
}
