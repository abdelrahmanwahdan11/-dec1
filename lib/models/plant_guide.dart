import 'package:flutter/material.dart';

enum GuideLevel { beginner, intermediate, advanced }

class PlantGuide {
  final String id;
  final String titleEn;
  final String titleAr;
  final String summaryEn;
  final String summaryAr;
  final String bodyEn;
  final String bodyAr;
  final String imageUrl;
  final List<String> tags;
  final int durationMinutes;
  final GuideLevel level;

  const PlantGuide({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.summaryEn,
    required this.summaryAr,
    required this.bodyEn,
    required this.bodyAr,
    required this.imageUrl,
    required this.tags,
    required this.durationMinutes,
    required this.level,
  });

  String localizedTitle(Locale locale) =>
      locale.languageCode == 'ar' ? titleAr : titleEn;

  String localizedSummary(Locale locale) =>
      locale.languageCode == 'ar' ? summaryAr : summaryEn;

  String localizedBody(Locale locale) =>
      locale.languageCode == 'ar' ? bodyAr : bodyEn;

  String get levelLabel {
    switch (level) {
      case GuideLevel.beginner:
        return 'beginner';
      case GuideLevel.intermediate:
        return 'intermediate';
      case GuideLevel.advanced:
        return 'advanced';
    }
  }
}
