class GiftOption {
  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final double price;
  final String imageUrl;
  final String plantId;
  final String wrapHex;
  final bool includesCard;

  const GiftOption({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.price,
    required this.imageUrl,
    required this.plantId,
    required this.wrapHex,
    this.includesCard = true,
  });

  String localizedTitle(String code) => code == 'ar' ? titleAr : titleEn;
  String localizedDescription(String code) => code == 'ar' ? descriptionAr : descriptionEn;
}
