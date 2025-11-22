import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_guides.dart';
import '../data/mock_tips.dart';
import '../models/community_tip.dart';
import '../models/plant_guide.dart';

class GuidesController extends ChangeNotifier {
  static const _completedKey = 'completed_guides';
  static const _savedKey = 'saved_guides';
  static const _likedTipsKey = 'liked_tips';
  static const _bookmarkedTipsKey = 'bookmarked_tips';
  final ValueNotifier<List<PlantGuide>> guides =
      ValueNotifier<List<PlantGuide>>(mockGuides);
  final ValueNotifier<Set<String>> completed = ValueNotifier<Set<String>>({});
  final ValueNotifier<Set<String>> saved = ValueNotifier<Set<String>>({});
  final ValueNotifier<List<CommunityTip>> tips =
      ValueNotifier<List<CommunityTip>>(mockTips);
  final ValueNotifier<Set<String>> likedTips = ValueNotifier<Set<String>>({});
  final ValueNotifier<Set<String>> bookmarkedTips =
      ValueNotifier<Set<String>>({});

  GuidesController() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    completed.value = (prefs.getStringList(_completedKey) ?? []).toSet();
    saved.value = (prefs.getStringList(_savedKey) ?? []).toSet();
    likedTips.value = (prefs.getStringList(_likedTipsKey) ?? []).toSet();
    bookmarkedTips.value =
        (prefs.getStringList(_bookmarkedTipsKey) ?? []).toSet();
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

  List<CommunityTip> searchTips(String query, {String? category}) {
    Iterable<CommunityTip> filtered = tips.value;
    if (category != null && category.isNotEmpty) {
      filtered = filtered.where(
        (tip) => tip.category.toLowerCase() == category.toLowerCase(),
      );
    }
    if (query.isEmpty) return filtered.toList();
    final lower = query.toLowerCase();
    return filtered
        .where((tip) =>
            tip.titleEn.toLowerCase().contains(lower) ||
            tip.titleAr.contains(query) ||
            tip.bodyEn.toLowerCase().contains(lower) ||
            tip.bodyAr.contains(query) ||
            tip.tags.any((tag) => tag.toLowerCase().contains(lower)))
        .toList();
  }

  bool isTipLiked(String id) => likedTips.value.contains(id);

  bool isTipSaved(String id) => bookmarkedTips.value.contains(id);

  Future<void> toggleTipLike(String id) async {
    final updated = <String>{...likedTips.value};
    if (!updated.add(id)) {
      updated.remove(id);
    }
    likedTips.value = updated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_likedTipsKey, updated.toList());
  }

  Future<void> toggleTipSave(String id) async {
    final updated = <String>{...bookmarkedTips.value};
    if (!updated.add(id)) {
      updated.remove(id);
    }
    bookmarkedTips.value = updated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_bookmarkedTipsKey, updated.toList());
  }

  @override
  void dispose() {
    guides.dispose();
    completed.dispose();
    saved.dispose();
    tips.dispose();
    likedTips.dispose();
    bookmarkedTips.dispose();
    super.dispose();
  }
}
