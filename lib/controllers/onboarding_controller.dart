import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingController {
  static const _seenKey = 'seen_onboarding';
  final PageController pageController = PageController();
  final ValueNotifier<int> index = ValueNotifier<int>(0);
  Timer? _timer;

  void startAutoSlide(int pageCount) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      final next = index.value + 1;
      final target = next % pageCount;
      pageController.animateToPage(
        target,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  void onPageChanged(int value) {
    index.value = value;
  }

  Future<void> markSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_seenKey, true);
  }

  void dispose() {
    _timer?.cancel();
    pageController.dispose();
  }
}
