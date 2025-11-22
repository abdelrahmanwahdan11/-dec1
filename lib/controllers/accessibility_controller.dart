import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessibilityController extends ChangeNotifier {
  static const _textScaleKey = 'text_scale';
  static const _reduceMotionKey = 'reduce_motion';
  static const _highContrastKey = 'high_contrast';
  static const _analyticsKey = 'analytics_opt_in';
  static const _personalizationKey = 'personalization_opt_in';
  static const _emailTipsKey = 'email_tips_opt_in';

  double _textScale;
  bool _reduceMotion;
  bool _highContrast;
  bool _allowAnalytics;
  bool _allowPersonalization;
  bool _allowEmailTips;

  AccessibilityController({double textScale = 1.0, bool reduceMotion = false, bool highContrast = false})
      : _textScale = textScale,
        _reduceMotion = reduceMotion,
        _highContrast = highContrast,
        _allowAnalytics = true,
        _allowPersonalization = true,
        _allowEmailTips = true;

  AccessibilityController.withPrivacy({
    double textScale = 1.0,
    bool reduceMotion = false,
    bool highContrast = false,
    bool allowAnalytics = true,
    bool allowPersonalization = true,
    bool allowEmailTips = true,
  })  : _textScale = textScale,
        _reduceMotion = reduceMotion,
        _highContrast = highContrast,
        _allowAnalytics = allowAnalytics,
        _allowPersonalization = allowPersonalization,
        _allowEmailTips = allowEmailTips;

  double get textScale => _textScale;
  bool get reduceMotion => _reduceMotion;
  bool get highContrast => _highContrast;
  bool get allowAnalytics => _allowAnalytics;
  bool get allowPersonalization => _allowPersonalization;
  bool get allowEmailTips => _allowEmailTips;

  Future<void> updateTextScale(double value) async {
    _textScale = value.clamp(0.9, 1.3);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_textScaleKey, _textScale);
    notifyListeners();
  }

  Future<void> toggleReduceMotion(bool value) async {
    _reduceMotion = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_reduceMotionKey, _reduceMotion);
    notifyListeners();
  }

  Future<void> toggleHighContrast(bool value) async {
    _highContrast = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_highContrastKey, _highContrast);
    notifyListeners();
  }

  Future<void> toggleAnalytics(bool value) async {
    _allowAnalytics = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_analyticsKey, _allowAnalytics);
    notifyListeners();
  }

  Future<void> togglePersonalization(bool value) async {
    _allowPersonalization = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_personalizationKey, _allowPersonalization);
    notifyListeners();
  }

  Future<void> toggleEmailTips(bool value) async {
    _allowEmailTips = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_emailTipsKey, _allowEmailTips);
    notifyListeners();
  }
}
