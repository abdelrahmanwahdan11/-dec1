import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessibilityController extends ChangeNotifier {
  static const _textScaleKey = 'text_scale';
  static const _reduceMotionKey = 'reduce_motion';
  static const _highContrastKey = 'high_contrast';

  double _textScale;
  bool _reduceMotion;
  bool _highContrast;

  AccessibilityController({double textScale = 1.0, bool reduceMotion = false, bool highContrast = false})
      : _textScale = textScale,
        _reduceMotion = reduceMotion,
        _highContrast = highContrast;

  double get textScale => _textScale;
  bool get reduceMotion => _reduceMotion;
  bool get highContrast => _highContrast;

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
}
