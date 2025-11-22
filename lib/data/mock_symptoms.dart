import '../models/plant_symptom.dart';

final mockSymptoms = <PlantSymptom>[
  PlantSymptom(
    id: 'symptom-yellow',
    titleEn: 'Yellowing leaves',
    titleAr: 'اصفرار الأوراق',
    descriptionEn: 'Common after overwatering or low nutrients.',
    descriptionAr: 'يحدث غالباً بسبب كثرة الري أو نقص المغذيات.',
    stepsEn: const [
      'Check the top soil and let it dry before the next watering.',
      'Trim the most faded leaves to push fresh growth.',
      'Add a balanced fertilizer in the next watering.',
    ],
    stepsAr: const [
      'افحص التربة واتركها تجف قبل الري القادم.',
      'قم بقص الأوراق الأكثر بهتاناً لتحفيز نمو جديد.',
      'أضف سماداً متوازناً مع الري القادم.',
    ],
    severity: SymptomSeverity.medium,
  ),
  PlantSymptom(
    id: 'symptom-droop',
    titleEn: 'Drooping stems',
    titleAr: 'سيقان مترهلة',
    descriptionEn: 'Happens after underwatering or sudden temperature changes.',
    descriptionAr: 'يحدث بسبب نقص الري أو تغير الحرارة المفاجئ.',
    stepsEn: const [
      'Water slowly until excess drains out.',
      'Move the plant away from AC vents or heaters.',
      'Rotate the pot to balance light.',
    ],
    stepsAr: const [
      'اروِ ببطء حتى يخرج الماء الزائد.',
      'أبعد النبات عن فتحات المكيف أو المدفأة.',
      'قم بتدوير الأصيص لتحقيق توازن الإضاءة.',
    ],
    severity: SymptomSeverity.low,
  ),
  PlantSymptom(
    id: 'symptom-crisp',
    titleEn: 'Crispy edges',
    titleAr: 'أطراف جافة',
    descriptionEn: 'Low humidity and intense sun can crisp delicate leaves.',
    descriptionAr: 'الرطوبة المنخفضة والشمس المباشرة تجفف الأوراق الحساسة.',
    stepsEn: const [
      'Mist lightly in the morning or add a pebble tray.',
      'Diffuse harsh sunlight with a curtain.',
      'Increase watering frequency slightly for this week.',
    ],
    stepsAr: const [
      'رش خفيف صباحاً أو ضع صينية حصى مع ماء.',
      'خفف الشمس القوية بستارة.',
      'زد وتيرة الري قليلاً لهذا الأسبوع.',
    ],
    severity: SymptomSeverity.medium,
  ),
  PlantSymptom(
    id: 'symptom-pests',
    titleEn: 'Tiny pests',
    titleAr: 'حشرات صغيرة',
    descriptionEn: 'Spider mites or aphids show up as dots under leaves.',
    descriptionAr: 'عث العنكبوت أو المن يظهر كنقاط أسفل الأوراق.',
    stepsEn: const [
      'Shower foliage with lukewarm water to knock pests off.',
      'Wipe leaves with diluted soap solution.',
      'Isolate the plant from the rest for a week.',
    ],
    stepsAr: const [
      'اغسل الأوراق بماء فاتر لإزالة الحشرات.',
      'امسح الأوراق بمحلول صابون مخفف.',
      'اعزل النبات عن البقية لمدة أسبوع.',
    ],
    severity: SymptomSeverity.high,
  ),
];
