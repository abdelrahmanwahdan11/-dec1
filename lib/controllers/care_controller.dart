import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_care_tasks.dart';
import '../models/plant_care_task.dart';

class CareController extends ChangeNotifier {
  CareController() {
    _load();
  }

  final ValueNotifier<List<PlantCareTask>> tasks =
      ValueNotifier<List<PlantCareTask>>(mockCareTasks);
  late SharedPreferences _prefs;
  bool _ready = false;
  final Set<String> _completedIds = {};
  final Map<String, DateTime> _dueOverrides = {};

  Future<void> _load() async {
    _prefs = await SharedPreferences.getInstance();
    _ready = true;
    final completed = _prefs.getStringList('care_completed_ids') ?? [];
    _completedIds
      ..clear()
      ..addAll(completed);
    final overridesRaw = _prefs.getStringList('care_due_overrides') ?? [];
    _dueOverrides
      ..clear()
      ..addEntries(overridesRaw.map((entry) {
        final parts = entry.split('|');
        return MapEntry(parts.first, DateTime.fromMillisecondsSinceEpoch(int.parse(parts.last)));
      }));
    _hydrate();
  }

  void _hydrate() {
    tasks.value = mockCareTasks
        .map((t) => t.copyWith(
              completed: _completedIds.contains(t.id),
              dueDate: _dueOverrides[t.id] ?? t.dueDate,
            ))
        .toList();
  }

  Future<void> toggleComplete(String id) async {
    if (!_ready) {
      await _load();
    }
    if (_completedIds.contains(id)) {
      _completedIds.remove(id);
    } else {
      _completedIds.add(id);
    }
    await _prefs.setStringList('care_completed_ids', _completedIds.toList());
    _hydrate();
    notifyListeners();
  }

  Future<void> postpone(String id, {Duration by = const Duration(hours: 24)}) async {
    if (!_ready) {
      await _load();
    }
    final current = _dueOverrides[id] ??
        tasks.value.firstWhere((element) => element.id == id).dueDate;
    final updated = current.add(by);
    _dueOverrides[id] = updated;
    await _prefs.setStringList(
      'care_due_overrides',
      _dueOverrides.entries.map((e) => '${e.key}|${e.value.millisecondsSinceEpoch}').toList(),
    );
    _hydrate();
    notifyListeners();
  }

  @override
  void dispose() {
    tasks.dispose();
    super.dispose();
  }
}
