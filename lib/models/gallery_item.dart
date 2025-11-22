class GalleryItem {
  final String id;
  final String titleEn;
  final String titleAr;
  final String captionEn;
  final String captionAr;
  final String imageUrl;
  final List<String> tags;

  const GalleryItem({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.captionEn,
    required this.captionAr,
    required this.imageUrl,
    required this.tags,
  });

  String localizedTitle(String code) => code == 'ar' ? titleAr : titleEn;

  String localizedCaption(String code) => code == 'ar' ? captionAr : captionEn;
}
