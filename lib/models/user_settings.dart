import 'package:flutter/material.dart';

enum AppThemeMode { light, dark, system }

@immutable
class UserSettings {
  final AppThemeMode themeMode;
  final String primaryColorHex;
  final String localeCode;
  final bool seenOnboarding;
  final bool isGuest;
  final double textScale;
  final bool reduceMotion;
  final bool highContrast;
  final bool allowAnalytics;
  final bool allowPersonalization;
  final bool allowEmailTips;

  const UserSettings({
    required this.themeMode,
    required this.primaryColorHex,
    required this.localeCode,
    required this.seenOnboarding,
    required this.isGuest,
    this.textScale = 1.0,
    this.reduceMotion = false,
    this.highContrast = false,
    this.allowAnalytics = true,
    this.allowPersonalization = true,
    this.allowEmailTips = true,
  });

  UserSettings copyWith({
    AppThemeMode? themeMode,
    String? primaryColorHex,
    String? localeCode,
    bool? seenOnboarding,
    bool? isGuest,
    double? textScale,
    bool? reduceMotion,
    bool? highContrast,
    bool? allowAnalytics,
    bool? allowPersonalization,
    bool? allowEmailTips,
  }) {
    return UserSettings(
      themeMode: themeMode ?? this.themeMode,
      primaryColorHex: primaryColorHex ?? this.primaryColorHex,
      localeCode: localeCode ?? this.localeCode,
      seenOnboarding: seenOnboarding ?? this.seenOnboarding,
      isGuest: isGuest ?? this.isGuest,
      textScale: textScale ?? this.textScale,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      highContrast: highContrast ?? this.highContrast,
      allowAnalytics: allowAnalytics ?? this.allowAnalytics,
      allowPersonalization:
          allowPersonalization ?? this.allowPersonalization,
      allowEmailTips: allowEmailTips ?? this.allowEmailTips,
    );
  }
}
