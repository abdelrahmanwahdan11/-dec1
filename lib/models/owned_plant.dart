import 'dart:convert';

import 'plant.dart';

enum PlantHealth { thriving, steady, struggling }

class OwnedPlant {
  final String plantId;
  final String nameEn;
  final String nameAr;
  final String imageUrl;
  final String nickname;
  final String location;
  final PlantHealth health;
  final DateTime acquiredAt;
  final DateTime lastWatered;
  final DateTime nextWatering;

  OwnedPlant({
    required this.plantId,
    required this.nameEn,
    required this.nameAr,
    required this.imageUrl,
    required this.nickname,
    required this.location,
    required this.health,
    required this.acquiredAt,
    required this.lastWatered,
    required this.nextWatering,
  });

  OwnedPlant copyWith({
    String? nickname,
    String? location,
    PlantHealth? health,
    DateTime? lastWatered,
    DateTime? nextWatering,
  }) {
    return OwnedPlant(
      plantId: plantId,
      nameEn: nameEn,
      nameAr: nameAr,
      imageUrl: imageUrl,
      nickname: nickname ?? this.nickname,
      location: location ?? this.location,
      health: health ?? this.health,
      acquiredAt: acquiredAt,
      lastWatered: lastWatered ?? this.lastWatered,
      nextWatering: nextWatering ?? this.nextWatering,
    );
  }

  String displayName(String localeCode) =>
      nickname.isNotEmpty ? nickname : localeCode == 'ar' ? nameAr : nameEn;

  Map<String, dynamic> toMap() {
    return {
      'plantId': plantId,
      'nameEn': nameEn,
      'nameAr': nameAr,
      'imageUrl': imageUrl,
      'nickname': nickname,
      'location': location,
      'health': health.name,
      'acquiredAt': acquiredAt.toIso8601String(),
      'lastWatered': lastWatered.toIso8601String(),
      'nextWatering': nextWatering.toIso8601String(),
    };
  }

  factory OwnedPlant.fromMap(Map<String, dynamic> map) {
    return OwnedPlant(
      plantId: map['plantId'] as String,
      nameEn: map['nameEn'] as String,
      nameAr: map['nameAr'] as String,
      imageUrl: map['imageUrl'] as String,
      nickname: map['nickname'] as String? ?? '',
      location: map['location'] as String? ?? '',
      health: PlantHealth.values.firstWhere(
        (e) => e.name == map['health'],
        orElse: () => PlantHealth.steady,
      ),
      acquiredAt: DateTime.tryParse(map['acquiredAt'] ?? '') ?? DateTime.now(),
      lastWatered: DateTime.tryParse(map['lastWatered'] ?? '') ?? DateTime.now(),
      nextWatering: DateTime.tryParse(map['nextWatering'] ?? '') ??
          DateTime.now().add(const Duration(days: 3)),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory OwnedPlant.fromJson(String source) =>
      OwnedPlant.fromMap(jsonDecode(source) as Map<String, dynamic>);

  factory OwnedPlant.fromPlant(Plant plant) {
    final now = DateTime.now();
    return OwnedPlant(
      plantId: plant.id,
      nameEn: plant.nameEn,
      nameAr: plant.nameAr,
      imageUrl: plant.imageUrl,
      nickname: '',
      location: 'Living room',
      health: PlantHealth.thriving,
      acquiredAt: now.subtract(const Duration(days: 30)),
      lastWatered: now.subtract(const Duration(days: 2)),
      nextWatering: now.add(const Duration(days: 2)),
    );
  }
}
