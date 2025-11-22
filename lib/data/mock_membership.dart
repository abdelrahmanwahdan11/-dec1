import '../models/membership_perk.dart';
import '../models/membership_status.dart';

final mockMembership = MembershipStatus(
  tier: 'Sprout',
  points: 420,
  nextTierAt: 750,
  perks: const [
    MembershipPerk(
      id: 'shipping',
      titleEn: 'Free shipping weekend',
      titleAr: 'توصيل مجاني في عطلة نهاية الأسبوع',
      descriptionEn: 'Use once this month to waive delivery fees.',
      descriptionAr: 'استخدمها مرة هذا الشهر لإلغاء رسوم التوصيل.',
    ),
    MembershipPerk(
      id: 'carepack',
      titleEn: 'Care pack bonus',
      titleAr: 'حزمة عناية إضافية',
      descriptionEn: 'Claim a mister + wipes add-on with your next order.',
      descriptionAr: 'احصل على بخاخ ومناديل مع طلبك القادم.',
    ),
    MembershipPerk(
      id: 'double',
      titleEn: 'Double points day',
      titleAr: 'يوم نقاط مضاعفة',
      descriptionEn: 'Pick a day to double rewards on purchases.',
      descriptionAr: 'اختر يومًا لمضاعفة النقاط على المشتريات.',
    ),
  ],
);
