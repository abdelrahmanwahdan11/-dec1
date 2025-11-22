import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_symptoms.dart';
import '../models/plant_symptom.dart';

class DiagnosticsController extends ChangeNotifier {
  DiagnosticsController() {
    _load();
  }

  final ValueNotifier<List<PlantSymptom>> symptoms =
      ValueNotifier<List<PlantSymptom>>(mockSymptoms);
  SymptomSeverity? _filter;
  late SharedPreferences _prefs;
  bool _ready = false;
  final Set<String> _resolved = {};

  Future<void> _load() async {
    _prefs = await SharedPreferences.getInstance();
    _ready = true;
    final saved = _prefs.getStringList('diagnostics_resolved') ?? [];
    _resolved
      ..clear()
      ..addAll(saved);
    _hydrate();
  }

  void _hydrate() {
    var list = mockSymptoms
        .map((s) => s.copyWith(resolved: _resolved.contains(s.id)))
        .toList();
    if (_filter != null) {
      list = list.where((s) => s.severity == _filter).toList();
    }
    symptoms.value = list;
  }

  void setFilter(SymptomSeverity? severity) {
    _filter = severity;
    _hydrate();
    notifyListeners();
  }

  SymptomSeverity? get currentFilter => _filter;

  Future<void> toggleResolved(String id) async {
    if (!_ready) {
      await _load();
    }
    if (_resolved.contains(id)) {
      _resolved.remove(id);
    } else {
      _resolved.add(id);
    }
    await _prefs.setStringList('diagnostics_resolved', _resolved.toList());
    _hydrate();
    notifyListeners();
  }

  @override
  void dispose() {
    symptoms.dispose();
    super.dispose();
  }
}
