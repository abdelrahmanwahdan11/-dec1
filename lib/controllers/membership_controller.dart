import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_membership.dart';
import '../models/membership_perk.dart';
import '../models/membership_status.dart';

class MembershipController extends ChangeNotifier {
  static const _pointsKey = 'membership_points';
  static const _tierKey = 'membership_tier';
  static const _claimedKey = 'membership_claimed';

  final ValueNotifier<MembershipStatus> status = ValueNotifier(mockMembership);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final storedPoints = prefs.getInt(_pointsKey);
    final storedTier = prefs.getString(_tierKey);
    final claimed = prefs.getStringList(_claimedKey) ?? [];
    final current = mockMembership.copyWith(
      tier: storedTier ?? mockMembership.tier,
      points: storedPoints ?? mockMembership.points,
      perks: mockMembership.perks
          .map((perk) => perk.copyWith(claimed: claimed.contains(perk.id)))
          .toList(),
    );
    status.value = current;
  }

  Future<void> claimPerk(String id) async {
    final current = status.value;
    final perks = current.perks
        .map((perk) => perk.id == id ? perk.copyWith(claimed: true) : perk)
        .toList();
    final updated = current.copyWith(perks: perks);
    status.value = updated;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_claimedKey, perks.where((p) => p.claimed).map((p) => p.id).toList());
  }

  Future<void> addPoints(int delta) async {
    final updatedPoints = status.value.points + delta;
    status.value = status.value.copyWith(points: updatedPoints);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_pointsKey, updatedPoints);
  }

  Future<void> updateTier(String tier) async {
    status.value = status.value.copyWith(tier: tier);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tierKey, tier);
  }

  @override
  void dispose() {
    status.dispose();
    super.dispose();
  }
}
