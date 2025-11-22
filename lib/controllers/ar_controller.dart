import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/mock_ar_scenes.dart';
import '../models/ar_scene.dart';

class ArController {
  static const _sceneKey = 'ar_scene';
  static const _scaleKey = 'ar_scale';
  static const _shadowKey = 'ar_shadow';
  static const _gridKey = 'ar_grid';

  ArController() {
    _load();
  }

  final ValueNotifier<ArScene> scene = ValueNotifier<ArScene>(mockArScenes.first);
  final ValueNotifier<double> scale = ValueNotifier<double>(1.0);
  final ValueNotifier<bool> showShadow = ValueNotifier<bool>(true);
  final ValueNotifier<bool> showGrid = ValueNotifier<bool>(false);

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final sceneId = prefs.getString(_sceneKey);
    final savedScene = mockArScenes.where((s) => s.id == sceneId).cast<ArScene?>().firstOrNull;
    if (savedScene != null) scene.value = savedScene;
    scale.value = prefs.getDouble(_scaleKey) ?? 1.0;
    showShadow.value = prefs.getBool(_shadowKey) ?? true;
    showGrid.value = prefs.getBool(_gridKey) ?? false;
  }

  Future<void> selectScene(ArScene target) async {
    scene.value = target;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sceneKey, target.id);
  }

  Future<void> updateScale(double value) async {
    scale.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_scaleKey, value);
  }

  Future<void> toggleShadow(bool value) async {
    showShadow.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_shadowKey, value);
  }

  Future<void> toggleGrid(bool value) async {
    showGrid.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_gridKey, value);
  }

  void dispose() {
    scene.dispose();
    scale.dispose();
    showShadow.dispose();
    showGrid.dispose();
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
