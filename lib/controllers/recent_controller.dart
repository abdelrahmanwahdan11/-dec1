import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentController extends ChangeNotifier {
  static const _storageKey = 'recent_plants';
  final ValueNotifier<List<String>> ids = ValueNotifier<List<String>>([]);

  RecentController() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    ids.value = prefs.getStringList(_storageKey) ?? [];
  }

  Future<void> add(String id) async {
    final updated = List<String>.from(ids.value);
    updated.remove(id);
    updated.insert(0, id);
    if (updated.length > 12) {
      updated.removeRange(12, updated.length);
    }
    ids.value = updated;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, updated);
  }

  Future<void> clear() async {
    ids.value = [];
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  @override
  void dispose() {
    ids.dispose();
    super.dispose();
  }
}
