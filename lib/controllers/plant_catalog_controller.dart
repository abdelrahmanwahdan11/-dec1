import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_plants.dart';
import '../models/plant.dart';

class PlantCatalogState {
  final List<Plant> items;
  final bool isLoading;
  final int page;
  final bool hasMore;

  PlantCatalogState({
    required this.items,
    required this.isLoading,
    required this.page,
    required this.hasMore,
  });

  PlantCatalogState copyWith({
    List<Plant>? items,
    bool? isLoading,
    int? page,
    bool? hasMore,
  }) {
    return PlantCatalogState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class PlantCatalogController {
  static const _pageSize = 4;
  static const _recentKey = 'recent_searches';
  final _stateController = StreamController<PlantCatalogState>.broadcast();
  final List<Plant> _all = mockPlants;
  String _search = '';
  PlantCategory? _category;
  PlantDifficulty? _difficulty;
  int _page = 1;
  bool _isLoading = false;
  final ValueNotifier<List<String>> recentSearches = ValueNotifier<List<String>>([]);

  Stream<PlantCatalogState> get stream => _stateController.stream;

  PlantCatalogController() {
    _emit();
    _loadRecentSearches();
    loadPage(reset: true);
  }

  PlantCategory? get category => _category;
  PlantDifficulty? get difficulty => _difficulty;

  void _emit() {
    final filtered = _filter();
    final pageItems = filtered.take(_page * _pageSize).toList();
    _stateController.add(
      PlantCatalogState(
        items: pageItems,
        isLoading: _isLoading,
        page: _page,
        hasMore: pageItems.length < filtered.length,
      ),
    );
  }

  List<Plant> _filter() {
    final query = _search.toLowerCase();
    return _all.where((p) {
      final matchesSearch = query.isEmpty ||
          p.nameEn.toLowerCase().contains(query) ||
          p.nameAr.toLowerCase().contains(query) ||
          p.tags.any((t) => t.toLowerCase().contains(query)) ||
          p.shortDescriptionEn.toLowerCase().contains(query) ||
          p.shortDescriptionAr.toLowerCase().contains(query) ||
          p.longDescriptionEn.toLowerCase().contains(query) ||
          p.longDescriptionAr.toLowerCase().contains(query);
      final matchesCategory = _category == null || p.category == _category;
      final matchesDifficulty = _difficulty == null || p.difficulty == _difficulty;
      return matchesSearch && matchesCategory && matchesDifficulty;
    }).toList();
  }

  Future<void> loadPage({bool reset = false}) async {
    if (_isLoading) return;
    if (reset) {
      _page = 1;
      _isLoading = true;
      _emit();
    }
    _isLoading = true;
    _emit();
    await Future.delayed(const Duration(milliseconds: 450));
    if (!reset) {
      _page += 1;
    }
    _isLoading = false;
    _emit();
  }

  void search(String query) {
    _search = query;
    _page = 1;
    _emit();
  }

  Future<void> rememberSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    final updated = List<String>.from(recentSearches.value);
    updated.remove(trimmed);
    updated.insert(0, trimmed);
    if (updated.length > 6) {
      updated.removeRange(6, updated.length);
    }
    recentSearches.value = updated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_recentKey, updated);
  }

  Future<void> clearRecent() async {
    recentSearches.value = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recentKey);
  }

  void setCategory(PlantCategory? category) {
    _category = category;
    _page = 1;
    _emit();
  }

  void setDifficulty(PlantDifficulty? difficulty) {
    _difficulty = difficulty;
    _page = 1;
    _emit();
  }

  void dispose() {
    recentSearches.dispose();
    _stateController.close();
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    recentSearches.value = prefs.getStringList(_recentKey) ?? [];
  }
}
