import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/mock_achievements.dart';
import '../models/achievement.dart';
import 'rewards_controller.dart';

class AchievementsController {
  static const _completedKey = 'achievements_completed';

  AchievementsController(this.rewardsController) {
    _load();
  }

  final RewardsController rewardsController;
  final ValueNotifier<Set<String>> completed = ValueNotifier<Set<String>>({});

  List<Achievement> get achievements => mockAchievements;

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    completed.value = (prefs.getStringList(_completedKey) ?? []).toSet();
  }

  bool isCompleted(String id) => completed.value.contains(id);

  Future<void> toggleComplete(Achievement achievement) async {
    final updated = <String>{...completed.value};
    if (updated.contains(achievement.id)) {
      updated.remove(achievement.id);
    } else {
      updated.add(achievement.id);
      await rewardsController.addPoints(achievement.points);
      await rewardsController.markAction('achievement_${achievement.id}');
    }
    completed.value = updated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_completedKey, updated.toList());
  }

  void dispose() {
    completed.dispose();
  }
}
