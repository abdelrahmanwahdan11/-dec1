import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChallengesState {
  final Map<String, int> progress;

  const ChallengesState({required this.progress});

  bool isComplete(String id, int target) => (progress[id] ?? 0) >= target;

  double progressFor(String id, int target) {
    final value = progress[id] ?? 0;
    return value.clamp(0, target) / target;
  }
}

class ChallengesController {
  final ValueNotifier<ChallengesState> state =
      ValueNotifier(const ChallengesState(progress: {}));

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('challenge_progress') ?? [];
    final progress = <String, int>{};
    for (final entry in saved) {
      final parts = entry.split(':');
      if (parts.length == 2) {
        final value = int.tryParse(parts[1]);
        if (value != null) progress[parts[0]] = value;
      }
    }
    state.value = ChallengesState(progress: progress);
  }

  Future<void> increment(String id, int target) async {
    final current = state.value.progress[id] ?? 0;
    if (current >= target) return;
    final updated = Map<String, int>.from(state.value.progress)
      ..[id] = current + 1;
    state.value = ChallengesState(progress: updated);
    await _persist(updated);
  }

  Future<void> reset(String id) async {
    final updated = Map<String, int>.from(state.value.progress);
    updated.remove(id);
    state.value = ChallengesState(progress: updated);
    await _persist(updated);
  }

  Future<void> _persist(Map<String, int> progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'challenge_progress',
      progress.entries.map((e) => '${e.key}:${e.value}').toList(),
    );
  }

  void dispose() {
    state.dispose();
  }
}
