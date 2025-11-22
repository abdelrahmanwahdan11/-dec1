import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/plant.dart';

class FavoritesController {
  static const _key = 'favorite_plant_ids';
  final ValueNotifier<Set<String>> favorites = ValueNotifier<Set<String>>({});

  FavoritesController() {
    _load();
  }

  bool isFavorite(String id) => favorites.value.contains(id);

  List<String> get ids => favorites.value.toList();

  Future<void> toggle(Plant plant) async {
    final updated = <String>{...favorites.value};
    if (!updated.add(plant.id)) {
      updated.remove(plant.id);
    }
    favorites.value = updated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, updated.toList());
  }

  Future<void> clear() async {
    favorites.value = {};
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_key) ?? [];
    favorites.value = stored.toSet();
  }

  void dispose() {
    favorites.dispose();
  }
}
