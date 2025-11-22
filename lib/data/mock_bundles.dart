import '../models/plant_bundle.dart';

final mockBundles = <PlantBundle>[
  PlantBundle(
    id: 'bundle1',
    titleEn: 'Starter Jungle',
    titleAr: 'حزمة البداية الخضراء',
    descriptionEn: 'Three forgiving plants to green any corner.',
    descriptionAr: 'ثلاث نباتات سهلة العناية لتزيين أي زاوية.',
    price: 59.99,
    imageUrl:
        'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?auto=format&fit=crop&w=1000&q=80&sat=-10',
    plantIds: const ['1', '2', '4'],
    highlight: 'Best for bright living rooms',
  ),
  PlantBundle(
    id: 'bundle2',
    titleEn: 'Desk Calm Kit',
    titleAr: 'مجموعة المكتب الهادئة',
    descriptionEn: 'Compact duo with air-purifying benefits.',
    descriptionAr: 'ثنائي مدمج ينقي الهواء ويهدئ المساحات.',
    price: 34.50,
    imageUrl:
        'https://images.unsplash.com/photo-1524592094714-0f0654e20314?auto=format&fit=crop&w=1000&q=80',
    plantIds: const ['2', '3'],
    highlight: 'Ship-ready with ceramic pots',
  ),
  PlantBundle(
    id: 'bundle3',
    titleEn: 'Giftable Blooms',
    titleAr: 'أزهار للهدايا',
    descriptionEn: 'Colorful mix with a handwritten card.',
    descriptionAr: 'مزيج ملون مع بطاقة مكتوبة بخط اليد.',
    price: 44.20,
    imageUrl:
        'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?auto=format&fit=crop&w=1000&q=80&sat=40',
    plantIds: const ['5', '6'],
    highlight: 'Perfect for celebrations',
  ),
];
