import '../models/achievement.dart';

const mockAchievements = <Achievement>[
  Achievement(
    id: 'care_streak',
    titleEn: 'Care streak',
    titleAr: 'سلسلة العناية',
    descriptionEn: 'Complete three consecutive care tasks without missing a day.',
    descriptionAr: 'أكمل ثلاث مهام عناية متتالية دون تفويت يوم.',
    points: 30,
    icon: '🌿',
  ),
  Achievement(
    id: 'order_first',
    titleEn: 'First order',
    titleAr: 'أول طلب',
    descriptionEn: 'Check out once to unlock a starter badge.',
    descriptionAr: 'أكمل عملية شراء لتحصل على الشارة الأولى.',
    points: 20,
    icon: '🛒',
  ),
  Achievement(
    id: 'community_helper',
    titleEn: 'Community helper',
    titleAr: 'مساند المجتمع',
    descriptionEn: 'Save or like five community tips to inspire others.',
    descriptionAr: 'احفظ أو سجل إعجاب بخمس نصائح مجتمعية لإلهام الآخرين.',
    points: 25,
    icon: '🤝',
  ),
  Achievement(
    id: 'garden_builder',
    titleEn: 'Garden builder',
    titleAr: 'منسق الحديقة',
    descriptionEn: 'Add three owned plants and water them in Garden.',
    descriptionAr: 'أضف ثلاث نباتات تملكها وقم بسقيها في الحديقة.',
    points: 35,
    icon: '🏡',
  ),
  Achievement(
    id: 'learning_champ',
    titleEn: 'Learning champ',
    titleAr: 'بطل التعلم',
    descriptionEn: 'Finish any quiz and one challenge to level up.',
    descriptionAr: 'أكمل أي اختبار وتحدٍ واحد للترقية.',
    points: 40,
    icon: '📚',
  ),
];
