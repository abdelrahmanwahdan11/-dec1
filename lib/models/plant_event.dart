class PlantEvent {
  final String id;
  final String titleEn;
  final String titleAr;
  final DateTime date;
  final String locationEn;
  final String locationAr;
  final String imageUrl;
  final String descriptionEn;
  final String descriptionAr;
  final String focusEn;
  final String focusAr;
  final bool isWorkshop;

  const PlantEvent({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.date,
    required this.locationEn,
    required this.locationAr,
    required this.imageUrl,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.focusEn,
    required this.focusAr,
    required this.isWorkshop,
  });

  String localizedTitle(String code) => code == 'ar' ? titleAr : titleEn;

  String localizedDescription(String code) =>
      code == 'ar' ? descriptionAr : descriptionEn;

  String localizedLocation(String code) => code == 'ar' ? locationAr : locationEn;

  String localizedFocus(String code) => code == 'ar' ? focusAr : focusEn;
}
