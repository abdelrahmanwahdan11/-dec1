import 'package:flutter/material.dart';

enum PlantCategory { indoor, outdoor, flower, cactus, tool }
enum PlantDifficulty { easy, medium, hard }

@immutable
class Plant {
  final String id;
  final String nameEn;
  final String nameAr;
  final double price;
  final String imageUrl;
  final PlantCategory category;
  final String heightRange;
  final String temperatureRange;
  final String humidity;
  final String shortDescriptionEn;
  final String shortDescriptionAr;
  final String longDescriptionEn;
  final String longDescriptionAr;
  final List<String> tags;
  final PlantDifficulty difficulty;

  const Plant({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.heightRange,
    required this.temperatureRange,
    required this.humidity,
    required this.shortDescriptionEn,
    required this.shortDescriptionAr,
    required this.longDescriptionEn,
    required this.longDescriptionAr,
    required this.tags,
    required this.difficulty,
  });

  String localizedName(Locale locale) => locale.languageCode == 'ar' ? nameAr : nameEn;
  String localizedShortDescription(Locale locale) =>
      locale.languageCode == 'ar' ? shortDescriptionAr : shortDescriptionEn;
  String localizedLongDescription(Locale locale) =>
      locale.languageCode == 'ar' ? longDescriptionAr : longDescriptionEn;
}
