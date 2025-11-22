class AppNotification {
  final String id;
  final String titleEn;
  final String titleAr;
  final String bodyEn;
  final String bodyAr;
  final DateTime timestamp;
  final bool read;

  const AppNotification({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.bodyEn,
    required this.bodyAr,
    required this.timestamp,
    this.read = false,
  });

  AppNotification copyWith({bool? read}) => AppNotification(
        id: id,
        titleEn: titleEn,
        titleAr: titleAr,
        bodyEn: bodyEn,
        bodyAr: bodyAr,
        timestamp: timestamp,
        read: read ?? this.read,
      );

  String localizedTitle(String code) => code == 'ar' ? titleAr : titleEn;
  String localizedBody(String code) => code == 'ar' ? bodyAr : bodyEn;
}
