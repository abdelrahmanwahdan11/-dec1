import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_gallery.dart';
import '../models/gallery_item.dart';

class GalleryController extends ChangeNotifier {
  static const _likedKey = 'gallery_likes';
  final ValueNotifier<List<GalleryItem>> gallery = ValueNotifier(mockGallery);
  final ValueNotifier<Set<String>> liked = ValueNotifier({});

  GalleryController() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    liked.value = (prefs.getStringList(_likedKey) ?? []).toSet();
  }

  bool isLiked(String id) => liked.value.contains(id);

  Future<void> toggleLike(String id) async {
    final updated = <String>{...liked.value};
    if (!updated.add(id)) {
      updated.remove(id);
    }
    liked.value = updated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_likedKey, updated.toList());
  }

  List<GalleryItem> tagged(String tag) =>
      gallery.value.where((g) => g.tags.contains(tag)).toList();

  @override
  void dispose() {
    gallery.dispose();
    liked.dispose();
    super.dispose();
  }
}
