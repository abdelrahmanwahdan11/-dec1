import 'package:flutter/material.dart';

@immutable
class MembershipPerk {
  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final bool claimed;

  const MembershipPerk({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    this.claimed = false,
  });

  MembershipPerk copyWith({bool? claimed}) {
    return MembershipPerk(
      id: id,
      titleEn: titleEn,
      titleAr: titleAr,
      descriptionEn: descriptionEn,
      descriptionAr: descriptionAr,
      claimed: claimed ?? this.claimed,
    );
  }

  String localizedTitle(Locale locale) => locale.languageCode == 'ar' ? titleAr : titleEn;
  String localizedDescription(Locale locale) =>
      locale.languageCode == 'ar' ? descriptionAr : descriptionEn;
}
