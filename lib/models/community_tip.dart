import 'package:flutter/material.dart';

@immutable
class CommunityTip {
  final String id;
  final String titleEn;
  final String titleAr;
  final String bodyEn;
  final String bodyAr;
  final String category;
  final String level;
  final List<String> tags;
  final String? actionLabelEn;
  final String? actionLabelAr;

  const CommunityTip({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.bodyEn,
    required this.bodyAr,
    required this.category,
    required this.level,
    required this.tags,
    this.actionLabelEn,
    this.actionLabelAr,
  });
}
