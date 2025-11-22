import 'package:flutter/material.dart';

class Coupon {
  final String code;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final double discountPercent;
  final double minSpend;
  final DateTime expiresAt;

  const Coupon({
    required this.code,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.discountPercent,
    required this.minSpend,
    required this.expiresAt,
  });

  String localizedTitle(Locale locale) =>
      locale.languageCode == 'ar' ? titleAr : titleEn;
  String localizedDescription(Locale locale) =>
      locale.languageCode == 'ar' ? descriptionAr : descriptionEn;

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  double discountAmount(double subtotal) {
    if (subtotal < minSpend || isExpired) return 0;
    return subtotal * discountPercent;
  }

  String percentageLabel() => '${(discountPercent * 100).round()}%';
}
