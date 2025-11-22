import '../models/quiz_question.dart';

final mockQuizQuestions = [
  QuizQuestion(
    id: 'light-spot',
    questionEn: 'Which light level suits most indoor foliage plants?',
    questionAr: 'ما مستوى الإضاءة المناسب لمعظم النباتات الداخلية؟',
    options: [
      QuizOption(textEn: 'Direct midday sun', textAr: 'شمس منتصف النهار المباشرة'),
      QuizOption(textEn: 'Bright, indirect light', textAr: 'إضاءة ساطعة غير مباشرة'),
      QuizOption(textEn: 'No light needed', textAr: 'لا تحتاج إلى ضوء'),
      QuizOption(textEn: 'Only evening light', textAr: 'ضوء المساء فقط'),
    ],
    correctIndex: 1,
    explanationEn: 'Bright, indirect light keeps leaves lush without scorching them.',
    explanationAr: 'الإضاءة الساطعة غير المباشرة تحافظ على الأوراق بدون حرق.',
  ),
  QuizQuestion(
    id: 'watering',
    questionEn: 'What is a good watering rule of thumb?',
    questionAr: 'ما القاعدة العامة الجيدة للري؟',
    options: [
      QuizOption(textEn: 'Water daily', textAr: 'الري يوميًا'),
      QuizOption(textEn: 'Soak constantly', textAr: 'نقع مستمر'),
      QuizOption(textEn: 'Let top soil dry a bit', textAr: 'اترك سطح التربة يجف قليلاً'),
      QuizOption(textEn: 'Only mist', textAr: 'رش بالرذاذ فقط'),
    ],
    correctIndex: 2,
    explanationEn: 'Letting the top layer dry avoids root rot for most plants.',
    explanationAr: 'ترك الطبقة العلوية تجف يمنع تعفن الجذور لمعظم النباتات.',
  ),
  QuizQuestion(
    id: 'humidity',
    questionEn: 'How can you boost humidity safely?',
    questionAr: 'كيف يمكن رفع الرطوبة بأمان؟',
    options: [
      QuizOption(textEn: 'Boil water nearby', textAr: 'غلي الماء بالقرب'),
      QuizOption(textEn: 'Use a pebble tray', textAr: 'استخدام صينية الحصى'),
      QuizOption(textEn: 'Seal the plant', textAr: 'تغليف النبات بالكامل'),
      QuizOption(textEn: 'Spray perfume', textAr: 'رش العطر'),
    ],
    correctIndex: 1,
    explanationEn: 'Pebble trays add gentle humidity without soaking roots.',
    explanationAr: 'صينية الحصى تضيف رطوبة لطيفة بدون إغراق الجذور.',
  ),
  QuizQuestion(
    id: 'repot',
    questionEn: 'When should you repot a fast grower?',
    questionAr: 'متى يجب إعادة التزيير لنبات سريع النمو؟',
    options: [
      QuizOption(textEn: 'When roots circle the pot', textAr: 'عندما تدور الجذور حول الأصيص'),
      QuizOption(textEn: 'Every month', textAr: 'كل شهر'),
      QuizOption(textEn: 'Only in winter', textAr: 'في الشتاء فقط'),
      QuizOption(textEn: 'Never repot', textAr: 'لا يعاد التزيير أبداً'),
    ],
    correctIndex: 0,
    explanationEn: 'Repotting when roots circle prevents stress and stunting.',
    explanationAr: 'إعادة التزيير عند التفاف الجذور تمنع الإجهاد وتوقف النمو.',
  ),
];
