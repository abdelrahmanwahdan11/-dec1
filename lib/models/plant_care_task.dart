import 'package:flutter/material.dart';

class PlantCareTask {
  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final DateTime dueDate;
  final String frequencyLabel;
  final bool completed;

  const PlantCareTask({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.dueDate,
    required this.frequencyLabel,
    this.completed = false,
  });

  PlantCareTask copyWith({
    DateTime? dueDate,
    bool? completed,
  }) {
    return PlantCareTask(
      id: id,
      titleEn: titleEn,
      titleAr: titleAr,
      descriptionEn: descriptionEn,
      descriptionAr: descriptionAr,
      dueDate: dueDate ?? this.dueDate,
      frequencyLabel: frequencyLabel,
      completed: completed ?? this.completed,
    );
  }

  String localizedTitle(Locale locale) =>
      locale.languageCode == 'ar' ? titleAr : titleEn;

  String localizedDescription(Locale locale) =>
      locale.languageCode == 'ar' ? descriptionAr : descriptionEn;
}
