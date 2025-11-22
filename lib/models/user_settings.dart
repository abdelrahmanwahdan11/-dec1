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

  const UserSettings({
    required this.themeMode,
    required this.primaryColorHex,
    required this.localeCode,
    required this.seenOnboarding,
    required this.isGuest,
    this.textScale = 1.0,
    this.reduceMotion = false,
    this.highContrast = false,
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
    );
  }
}
