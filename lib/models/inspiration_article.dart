class InspirationArticle {
  final String id;
  final String titleEn;
  final String titleAr;
  final String summaryEn;
  final String summaryAr;
  final String bodyEn;
  final String bodyAr;
  final String tag;
  final String heroImage;

  const InspirationArticle({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.summaryEn,
    required this.summaryAr,
    required this.bodyEn,
    required this.bodyAr,
    required this.tag,
    required this.heroImage,
  });

  String localizedTitle(String code) => code == 'ar' ? titleAr : titleEn;
  String localizedSummary(String code) => code == 'ar' ? summaryAr : summaryEn;
  String localizedBody(String code) => code == 'ar' ? bodyAr : bodyEn;
}
