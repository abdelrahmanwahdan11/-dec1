class UpdateNote {
  final String version;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final List<String> tags;
  final DateTime date;

  UpdateNote({
    required this.version,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.tags,
    required this.date,
  });

  String localizedTitle(String code) => code == 'ar' ? titleAr : titleEn;
  String localizedDescription(String code) => code == 'ar' ? descriptionAr : descriptionEn;
}
