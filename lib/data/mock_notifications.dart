import '../models/app_notification.dart';

final mockNotifications = [
  AppNotification(
    id: 'order-ship',
    titleEn: 'Order shipped',
    titleAr: 'تم شحن الطلب',
    bodyEn: 'Your fresh plants are on the way. Track in Orders.',
    bodyAr: 'نباتاتك في الطريق الآن. يمكنك المتابعة من صفحة الطلبات.',
    timestamp: DateTime.now().subtract(const Duration(hours: 3)),
  ),
  AppNotification(
    id: 'care-water',
    titleEn: 'Water reminder',
    titleAr: 'تذكير بالري',
    bodyEn: 'Monstera needs watering today. Keep the soil moist.',
    bodyAr: 'المونستيرا تحتاج ري اليوم. حافظ على التربة رطبة.',
    timestamp: DateTime.now().subtract(const Duration(hours: 12)),
  ),
  AppNotification(
    id: 'new-arrivals',
    titleEn: 'New arrivals',
    titleAr: 'إضافات جديدة',
    bodyEn: 'Discover colorful orchids and fresh herbs in the catalog.',
    bodyAr: 'اكتشف زهور الأوركيد الملونة والأعشاب الطازجة في الكتالوج.',
    timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
  ),
];
