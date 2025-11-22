import '../models/plant_challenge.dart';

final mockChallenges = [
  PlantChallenge(
    id: 'hydrate-3',
    titleEn: 'Water three plants',
    titleAr: 'اسقِ ثلاث نباتات',
    descriptionEn: 'Log three watering actions to unlock bonus points.',
    descriptionAr: 'سجّل ثلاث عمليات ري لتحصل على نقاط إضافية.',
    target: 3,
    rewardPoints: 25,
  ),
  PlantChallenge(
    id: 'sun-scan',
    titleEn: 'Check sunlight spots',
    titleAr: 'تحقق من أماكن الإضاءة',
    descriptionEn: 'Review two rooms and mark the best light corners.',
    descriptionAr: 'راجع غرفتين وحدد أفضل زوايا للضوء.',
    target: 2,
    rewardPoints: 15,
  ),
  PlantChallenge(
    id: 'share-tip',
    titleEn: 'Save a care tip',
    titleAr: 'احفظ نصيحة عناية',
    descriptionEn: 'Bookmark a guide or insight you plan to follow this week.',
    descriptionAr: 'احفظ دليلاً أو تلميحاً تريد تطبيقه هذا الأسبوع.',
    target: 1,
    rewardPoints: 10,
  ),
];
