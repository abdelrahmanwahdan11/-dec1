import 'package:flutter/material.dart';

enum AppThemeMode { light, dark, system }

@immutable
class UserSettings {
  final AppThemeMode themeMode;
  final String primaryColorHex;
  final String localeCode;
  final bool seenOnboarding;
  final bool isGuest;

  const UserSettings({
    required this.themeMode,
    required this.primaryColorHex,
    required this.localeCode,
    required this.seenOnboarding,
    required this.isGuest,
  });

  UserSettings copyWith({
    AppThemeMode? themeMode,
    String? primaryColorHex,
    String? localeCode,
    bool? seenOnboarding,
    bool? isGuest,
  }) {
    return UserSettings(
      themeMode: themeMode ?? this.themeMode,
      primaryColorHex: primaryColorHex ?? this.primaryColorHex,
      localeCode: localeCode ?? this.localeCode,
      seenOnboarding: seenOnboarding ?? this.seenOnboarding,
      isGuest: isGuest ?? this.isGuest,
    );
  }
}
