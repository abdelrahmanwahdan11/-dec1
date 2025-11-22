import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/mock_owned_plants.dart';
import '../models/owned_plant.dart';
import '../models/plant.dart';

class GardenController extends ChangeNotifier {
  static const _key = 'owned_plants';

  final ValueNotifier<List<OwnedPlant>> garden =
      ValueNotifier<List<OwnedPlant>>(mockOwnedPlants);

  GardenController() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_key);
    if (saved != null && saved.isNotEmpty) {
      garden.value = saved
          .map((e) => OwnedPlant.fromJson(e))
          .whereType<OwnedPlant>()
          .toList();
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = garden.value.map((e) => e.toJson()).toList();
    await prefs.setStringList(_key, encoded);
  }

  bool isOwned(String plantId) =>
      garden.value.any((element) => element.plantId == plantId);

  Future<void> addFromPlant(Plant plant, {String? nickname}) async {
    if (isOwned(plant.id)) return;
    final owned = OwnedPlant.fromPlant(plant).copyWith(
      nickname: nickname ?? '',
    );
    garden.value = [...garden.value, owned];
    await _save();
  }

  Future<void> markWatered(String plantId, {Duration interval = const Duration(days: 3)}) async {
    final now = DateTime.now();
    garden.value = garden.value
        .map((e) => e.plantId == plantId
            ? e.copyWith(
                lastWatered: now,
                nextWatering: now.add(interval),
              )
            : e)
        .toList();
    await _save();
  }

  Future<void> updateHealth(String plantId, PlantHealth health) async {
    garden.value = garden.value
        .map((e) => e.plantId == plantId ? e.copyWith(health: health) : e)
        .toList();
    await _save();
  }

  Future<void> remove(String plantId) async {
    garden.value = garden.value.where((e) => e.plantId != plantId).toList();
    await _save();
  }

  @override
  void dispose() {
    garden.dispose();
    super.dispose();
  }
}
