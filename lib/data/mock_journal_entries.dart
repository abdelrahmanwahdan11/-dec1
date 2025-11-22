import '../models/journal_entry.dart';

final mockJournalEntries = <JournalEntry>[
  JournalEntry(
    id: 'jn1',
    titleEn: 'Repotted the Monstera',
    titleAr: 'أعدت زراعة المونستيرا',
    noteEn: 'New airy mix with bark and perlite. Roots looked healthy.',
    noteAr: 'تربة خفيفة مع بيرلايت وخشب؛ الجذور بدت صحية.',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    imageUrl:
        'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?auto=format&fit=crop&w=900&q=80',
    mood: 'thriving',
    favorite: true,
  ),
  JournalEntry(
    id: 'jn2',
    titleEn: 'Misted the Calathea',
    titleAr: 'قمت برش الكالاتيا',
    noteEn: 'Leaf edges crispy, added pebble tray and moved away from AC.',
    noteAr: 'أطراف الأوراق جافة؛ وضعت صينية حصى وأبعدتها عن المكيف.',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    imageUrl:
        'https://images.unsplash.com/photo-1463320726281-696a485928c7?auto=format&fit=crop&w=900&q=80',
    mood: 'sensitive',
  ),
  JournalEntry(
    id: 'jn3',
    titleEn: 'Fiddle leaf dusting',
    titleAr: 'تنظيف ورق الفيكس',
    noteEn: 'Wiped leaves with neem spray and rotated pot for even light.',
    noteAr: 'مسحت الأوراق بزيت النيم وأدرت الأصيص للضوء المتوازن.',
    createdAt: DateTime.now().subtract(const Duration(days: 6)),
    imageUrl:
        'https://images.unsplash.com/photo-1524592094714-0f0654e20314?auto=format&fit=crop&w=900&q=80',
    mood: 'glossy',
  ),
];
