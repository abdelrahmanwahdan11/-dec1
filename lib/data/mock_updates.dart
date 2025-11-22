import '../models/update_note.dart';

final mockUpdates = <UpdateNote>[
  UpdateNote(
    version: '1.9.0',
    titleEn: 'Journal & update hub',
    titleAr: 'دفتر يوميات ومركز تحديثات',
    descriptionEn: 'Capture plant moments, favorite notes, and see what changed this release.',
    descriptionAr: 'سجّل لحظات نباتاتك، ميّز الملاحظات المفضلة، واطلع على جديد الإصدار.',
    tags: const ['journal', 'updates'],
    date: DateTime.now().subtract(const Duration(days: 1)),
  ),
  UpdateNote(
    version: '1.8.0',
    titleEn: 'Care calendar upgrade',
    titleAr: 'ترقية تقويم العناية',
    descriptionEn: 'Monthly tasks now animate in and sync with rewards and notifications.',
    descriptionAr: 'مهام الشهر تُعرض بتحريك وتتزامن مع المكافآت والإشعارات.',
    tags: const ['calendar', 'rewards'],
    date: DateTime.now().subtract(const Duration(days: 8)),
  ),
  UpdateNote(
    version: '1.7.0',
    titleEn: 'Gifting & Diagnostics polish',
    titleAr: 'تحسين الإهداء والتشخيص',
    descriptionEn: 'New plant doctor fixes, animated gifting builder, and loyalty hooks.',
    descriptionAr: 'إصلاحات للطبيب النباتي، منشئ هدايا متحرك، وارتباطات الولاء.',
    tags: const ['care', 'gifting'],
    date: DateTime.now().subtract(const Duration(days: 15)),
  ),
];
