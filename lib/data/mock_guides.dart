import '../models/plant_guide.dart';

const mockGuides = [
  PlantGuide(
    id: 'guide-1',
    titleEn: 'Low light heroes',
    titleAr: 'أبطال الإضاءة المنخفضة',
    summaryEn: 'Five resilient plants that stay lush in shaded corners.',
    summaryAr: 'خمسة نباتات قوية تبقى خضراء في الزوايا المظللة.',
    bodyEn:
        'Snake plants, ZZ plants, and pothos thrive with minimal light. Keep soil slightly dry, mist weekly, and rotate monthly for even growth.',
    bodyAr:
        'سانسيفيريا وزاميوكولكاس وبوثوس تنمو بإضاءة قليلة. حافظ على التربة شبه جافة، رش أسبوعياً، ودوّر الأصيص شهرياً لنمو متوازن.',
    imageUrl:
        'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?auto=format&fit=crop&w=600&q=60',
    tags: ['indoor', 'beginner', 'low-light'],
    durationMinutes: 4,
    level: GuideLevel.beginner,
  ),
  PlantGuide(
    id: 'guide-2',
    titleEn: 'Watering rhythm decoded',
    titleAr: 'إيقاع الري المثالي',
    summaryEn: 'Learn how to water by soil feel, season, and pot type.',
    summaryAr: 'تعلم الري حسب ملمس التربة، الفصل، ونوع الأصيص.',
    bodyEn:
        'Press soil to check moisture, water deeply then drain. Clay pots dry faster; in winter, reduce frequency and avoid cold water on roots.',
    bodyAr:
        'اضغط التربة للتحقق من الرطوبة، اسقِ بعمق ثم صفِّ الماء. الأصص الفخارية تجف أسرع؛ في الشتاء قلل الري وتجنب الماء البارد على الجذور.',
    imageUrl:
        'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?auto=format&fit=crop&w=600&q=60',
    tags: ['care', 'watering', 'intermediate'],
    durationMinutes: 6,
    level: GuideLevel.intermediate,
  ),
  PlantGuide(
    id: 'guide-3',
    titleEn: 'Humidity hacks for ferns',
    titleAr: 'حيل الرطوبة للسرخسيات',
    summaryEn: 'Create mini jungle humidity without special devices.',
    summaryAr: 'اصنع رطوبة غابة مصغرة دون أجهزة خاصة.',
    bodyEn:
        'Group plants together, place pebble trays with water, and run a morning mist. Bathrooms with windows are perfect for maidenhair ferns.',
    bodyAr:
        'اجمع النباتات معاً، استخدم صواني حصى مع ماء، ورش صباحي خفيف. الحمامات ذات النوافذ مثالية لسرخس شعر البنت.',
    imageUrl:
        'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?auto=format&fit=crop&w=600&q=60',
    tags: ['humidity', 'advanced', 'ferns'],
    durationMinutes: 5,
    level: GuideLevel.advanced,
  ),
];
