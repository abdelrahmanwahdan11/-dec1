import '../models/plant_event.dart';

final mockEvents = <PlantEvent>[
  PlantEvent(
    id: 'event-1',
    titleEn: 'Terrarium Lab Night',
    titleAr: 'ليلة تركيب التيراريوم',
    date: DateTime.now().add(const Duration(days: 2, hours: 3)),
    locationEn: 'Studio 23, Downtown',
    locationAr: 'ستوديو ٢٣ وسط المدينة',
    imageUrl:
        'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?auto=format&fit=crop&w=1200&q=80',
    descriptionEn: 'Layer moss, pebbles, and tropicals with guided steps.',
    descriptionAr: 'رتب الطحالب والحصى والنباتات الاستوائية بخطوات موجهة.',
    focusEn: 'Hands-on build, misting tips, and closed-jar care.',
    focusAr: 'تطبيق عملي ونصائح الرش والعناية بالوعاء المغلق.',
    isWorkshop: true,
  ),
  PlantEvent(
    id: 'event-2',
    titleEn: 'Sun Lovers Balcony Tour',
    titleAr: 'جولة شرفة عشاق الشمس',
    date: DateTime.now().add(const Duration(days: 6, hours: 1)),
    locationEn: 'Rooftop Garden, Block C',
    locationAr: 'حديقة السطح، المبنى ج',
    imageUrl:
        'https://images.unsplash.com/photo-1473186578172-c141e6798cf4?auto=format&fit=crop&w=1200&q=80',
    descriptionEn: 'Curated balcony setups with sun-mapped plant groupings.',
    descriptionAr: 'تنسيقات شرفات مع توزيع للنباتات حسب أشعة الشمس.',
    focusEn: 'Sun mapping, airflow tricks, and summer watering cadence.',
    focusAr: 'توزيع الضوء، حيل التهوية، وجدول الري الصيفي.',
    isWorkshop: false,
  ),
  PlantEvent(
    id: 'event-3',
    titleEn: 'Propagation Studio',
    titleAr: 'استوديو الإكثار',
    date: DateTime.now().add(const Duration(days: 10, hours: 4)),
    locationEn: 'Makers Hub, Hall B',
    locationAr: 'مركز الصناع، القاعة ب',
    imageUrl:
        'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?auto=format&fit=crop&w=1200&q=80',
    descriptionEn: 'Cut, root, and pot leaf/node cuttings with guided pacing.',
    descriptionAr: 'قص وتجذير وتركيب عقل الأوراق والسيقان بخطوات واضحة.',
    focusEn: 'Rooting media, humidity domes, and success checkpoints.',
    focusAr: 'وسائط التجذير، أغطية الرطوبة، ونقاط التحقق.',
    isWorkshop: true,
  ),
];
