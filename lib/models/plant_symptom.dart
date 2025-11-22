import 'package:flutter/material.dart';

enum SymptomSeverity { low, medium, high }

class PlantSymptom {
  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final List<String> stepsEn;
  final List<String> stepsAr;
  final SymptomSeverity severity;
  final bool resolved;

  const PlantSymptom({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.stepsEn,
    required this.stepsAr,
    required this.severity,
    this.resolved = false,
  });

  PlantSymptom copyWith({bool? resolved}) {
    return PlantSymptom(
      id: id,
      titleEn: titleEn,
      titleAr: titleAr,
      descriptionEn: descriptionEn,
      descriptionAr: descriptionAr,
      stepsEn: stepsEn,
      stepsAr: stepsAr,
      severity: severity,
      resolved: resolved ?? this.resolved,
    );
  }

  String localizedTitle(Locale locale) => locale.languageCode == 'ar' ? titleAr : titleEn;
  String localizedDescription(Locale locale) =>
      locale.languageCode == 'ar' ? descriptionAr : descriptionEn;
  List<String> localizedSteps(Locale locale) => locale.languageCode == 'ar' ? stepsAr : stepsEn;
}
