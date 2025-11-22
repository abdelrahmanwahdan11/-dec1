import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReferralController extends ChangeNotifier {
  static const _sentKey = 'referral_sent';
  static const _joinedKey = 'referral_joined';
  static const _rewardKey = 'referral_rewards';
  final ValueNotifier<int> invitesSent = ValueNotifier<int>(0);
  final ValueNotifier<int> friendsJoined = ValueNotifier<int>(0);
  final ValueNotifier<int> rewards = ValueNotifier<int>(120);
  final String code = 'PLANT-23-LOVE';

  ReferralController() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    invitesSent.value = prefs.getInt(_sentKey) ?? 0;
    friendsJoined.value = prefs.getInt(_joinedKey) ?? 0;
    rewards.value = prefs.getInt(_rewardKey) ?? 120;
  }

  Future<void> incrementSent() async {
    invitesSent.value += 1;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sentKey, invitesSent.value);
    notifyListeners();
  }

  Future<void> markJoined() async {
    friendsJoined.value += 1;
    rewards.value += 25;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_joinedKey, friendsJoined.value);
    await prefs.setInt(_rewardKey, rewards.value);
    notifyListeners();
  }

  @override
  void dispose() {
    invitesSent.dispose();
    friendsJoined.dispose();
    rewards.dispose();
    super.dispose();
  }
}
