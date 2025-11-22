import '../models/gallery_item.dart';

final mockGallery = <GalleryItem>[
  GalleryItem(
    id: 'gallery-1',
    titleEn: 'Monstera Corner',
    titleAr: 'زاوية المونستيرا',
    captionEn: 'Dappled light, layered textures, and a woven basket base.',
    captionAr: 'ضوء مرقط وطبقات خضراء مع سلة منسوجة.',
    imageUrl:
        'https://images.unsplash.com/photo-1524108697441-35506a7ba8f6?auto=format&fit=crop&w=1200&q=80',
    tags: const ['jungle', 'living_room', 'texture'],
  ),
  GalleryItem(
    id: 'gallery-2',
    titleEn: 'Desk Oasis',
    titleAr: 'واحة المكتب',
    captionEn: 'Low-profile cacti with a ripple tray and soft task lamp.',
    captionAr: 'صبار منخفض مع صينية متموجة وإضاءة مكتبية ناعمة.',
    imageUrl:
        'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?auto=format&fit=crop&w=1200&q=80',
    tags: const ['workspace', 'cactus', 'minimal'],
  ),
  GalleryItem(
    id: 'gallery-3',
    titleEn: 'Hydro Shelf',
    titleAr: 'رف الزراعة المائية',
    captionEn: 'Cuttings rooting in glass against a muted wall.',
    captionAr: 'عقل متجذرة في زجاج أمام جدار هادئ.',
    imageUrl:
        'https://images.unsplash.com/photo-1463320726281-696a485928c7?auto=format&fit=crop&w=1200&q=80',
    tags: const ['propagation', 'glass', 'bright'],
  ),
  GalleryItem(
    id: 'gallery-4',
    titleEn: 'Entryway Calm',
    titleAr: 'هدوء المدخل',
    captionEn: 'Layered ferns with a bench mist bottle and shoe tray.',
    captionAr: 'سرخس متدرج مع بخاخ مقعد وصينية أحذية.',
    imageUrl:
        'https://images.unsplash.com/photo-1526336024174-e58f5cdd8e13?auto=format&fit=crop&w=1200&q=80',
    tags: const ['entry', 'fern', 'mist'],
  ),
];
