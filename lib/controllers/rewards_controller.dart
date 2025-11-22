import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardsController {
  static const _pointsKey = 'reward_points';
  static const _badgesKey = 'reward_badges';

  RewardsController() {
    _load();
  }

  final ValueNotifier<int> points = ValueNotifier<int>(0);
  final ValueNotifier<Set<String>> badges = ValueNotifier<Set<String>>({});

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    points.value = prefs.getInt(_pointsKey) ?? 0;
    badges.value = (prefs.getStringList(_badgesKey) ?? []).toSet();
  }

  Future<void> addPoints(int value) async {
    if (value == 0) return;
    points.value += value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_pointsKey, points.value);
    await _maybeUnlockBadges();
  }

  Future<void> redeem(int value) async {
    if (value <= 0) return;
    points.value = (points.value - value).clamp(0, 999999);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_pointsKey, points.value);
  }

  Future<void> clearBadges() async {
    badges.value = {};
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_badgesKey);
  }

  Future<void> markAction(String badgeId) async {
    if (badges.value.contains(badgeId)) return;
    final updated = <String>{...badges.value, badgeId};
    badges.value = updated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_badgesKey, updated.toList());
  }

  Future<void> _maybeUnlockBadges() async {
    final milestones = [50, 120, 250];
    for (final milestone in milestones) {
      if (points.value >= milestone) {
        await markAction('points_$milestone');
      }
    }
  }

  void dispose() {
    points.dispose();
    badges.dispose();
  }
}
