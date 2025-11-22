import '../models/gift_option.dart';

final mockGiftOptions = <GiftOption>[
  const GiftOption(
    id: 'gift-joy',
    titleEn: 'Joyful Monstera',
    titleAr: 'مونستيرا مرحة',
    descriptionEn: 'Wrapped with satin ribbon and a handwritten card.',
    descriptionAr: 'تغليف بشريط ساتان وبطاقة مكتوبة بخط اليد.',
    price: 34.50,
    imageUrl:
        'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?auto=format&fit=crop&w=640&q=80&sat=10',
    plantId: '1',
    wrapHex: '#23A25D',
  ),
  const GiftOption(
    id: 'gift-purity',
    titleEn: 'Pure Peace Lily',
    titleAr: 'زنبق السلام الفاخر',
    descriptionEn: 'Glossy white wrap with gold seal and care note.',
    descriptionAr: 'تغليف أبيض لامع مع ختم ذهبي ومذكرة عناية.',
    price: 29.75,
    imageUrl:
        'https://images.unsplash.com/photo-1524592094714-0f0654e20314?auto=format&fit=crop&w=640&q=80',
    plantId: '2',
    wrapHex: '#E1E8F0',
  ),
  const GiftOption(
    id: 'gift-sun',
    titleEn: 'Sunny Cactus Trio',
    titleAr: 'ثلاثي الصبار المرح',
    descriptionEn: 'Kraft wrap, desert-inspired ribbon, and care booklet.',
    descriptionAr: 'تغليف كرافت وشريط مستوحى من الصحراء وكتيب عناية.',
    price: 22.40,
    imageUrl:
        'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?auto=format&fit=crop&w=640&q=80&sat=-20',
    plantId: '3',
    wrapHex: '#C08A3E',
  ),
];
