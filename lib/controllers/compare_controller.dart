import 'package:flutter/material.dart';
import '../models/plant.dart';

class CompareController {
  final ValueNotifier<List<Plant>> compared = ValueNotifier<List<Plant>>([]);

  void toggle(Plant plant) {
    final items = List<Plant>.from(compared.value);
    final index = items.indexWhere((p) => p.id == plant.id);
    if (index >= 0) {
      items.removeAt(index);
    } else {
      if (items.length >= 3) return;
      items.add(plant);
    }
    compared.value = items;
  }

  void clear() {
    compared.value = [];
  }
}
