import 'plant.dart';

class PlantBundle {
  final String id;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final double price;
  final String imageUrl;
  final List<String> plantIds;
  final String highlight;

  const PlantBundle({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.price,
    required this.imageUrl,
    required this.plantIds,
    required this.highlight,
  });

  String localizedTitle(String code) => code == 'ar' ? titleAr : titleEn;
  String localizedDescription(String code) => code == 'ar' ? descriptionAr : descriptionEn;
}
