import '../models/coupon.dart';

final mockCoupons = [
  Coupon(
    code: 'GREEN15',
    titleEn: 'Green Starter',
    titleAr: 'بداية خضراء',
    descriptionEn: '15% off orders above \$40 for your next plant haul.',
    descriptionAr: 'خصم 15٪ على الطلبات فوق 40 دولار لرحلتك النباتية القادمة.',
    discountPercent: 0.15,
    minSpend: 40,
    expiresAt: DateTime.now().add(const Duration(days: 30)),
  ),
  Coupon(
    code: 'BUNDLE20',
    titleEn: 'Bundle Boost',
    titleAr: 'دفعة الباقات',
    descriptionEn: '20% off when you try any curated bundle.',
    descriptionAr: 'خصم 20٪ عند تجربة أي باقة منسقة.',
    discountPercent: 0.20,
    minSpend: 55,
    expiresAt: DateTime.now().add(const Duration(days: 18)),
  ),
  Coupon(
    code: 'CAREMORE',
    titleEn: 'Care More',
    titleAr: 'اهتم أكثر',
    descriptionEn: '10% off to celebrate finishing three care tasks.',
    descriptionAr: 'خصم 10٪ للاحتفال بإنهاء ثلاث مهام عناية.',
    discountPercent: 0.10,
    minSpend: 25,
    expiresAt: DateTime.now().add(const Duration(days: 10)),
  ),
];
