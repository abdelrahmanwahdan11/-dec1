import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_guides.dart';
import '../models/plant_guide.dart';

class GuidesController extends ChangeNotifier {
  static const _completedKey = 'completed_guides';
  static const _savedKey = 'saved_guides';
  final ValueNotifier<List<PlantGuide>> guides =
      ValueNotifier<List<PlantGuide>>(mockGuides);
  final ValueNotifier<Set<String>> completed = ValueNotifier<Set<String>>({});
  final ValueNotifier<Set<String>> saved = ValueNotifier<Set<String>>({});

  GuidesController() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    completed.value = (prefs.getStringList(_completedKey) ?? []).toSet();
    saved.value = (prefs.getStringList(_savedKey) ?? []).toSet();
  }

  bool isCompleted(String id) => completed.value.contains(id);

  bool isSaved(String id) => saved.value.contains(id);

  Future<void> toggleSave(String id) async {
    final updated = <String>{...saved.value};
    if (!updated.add(id)) {
      updated.remove(id);
    }
    saved.value = updated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_savedKey, updated.toList());
  }

  Future<void> markCompleted(String id) async {
    final updated = <String>{...completed.value, id};
    completed.value = updated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_completedKey, updated.toList());
  }

  List<PlantGuide> search(String query) {
    if (query.isEmpty) return guides.value;
    final lower = query.toLowerCase();
    return guides.value
        .where((g) =>
            g.titleEn.toLowerCase().contains(lower) ||
            g.titleAr.contains(query) ||
            g.summaryEn.toLowerCase().contains(lower) ||
            g.summaryAr.contains(query) ||
            g.tags.any((tag) => tag.toLowerCase().contains(lower)))
        .toList();
  }

  List<PlantGuide> filterByLevel(GuideLevel? level) {
    if (level == null) return guides.value;
    return guides.value.where((g) => g.level == level).toList();
  }

  @override
  void dispose() {
    guides.dispose();
    completed.dispose();
    saved.dispose();
    super.dispose();
  }
}
