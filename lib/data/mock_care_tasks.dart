import '../models/plant_care_task.dart';

final mockCareTasks = [
  PlantCareTask(
    id: 'water-monstera',
    titleEn: 'Water Monstera',
    titleAr: 'اسقِ المونستيرا',
    descriptionEn: 'Give 300ml of water and wipe leaves for shine.',
    descriptionAr: 'أضف 300 مل ماء ونظف الأوراق لتلميعها.',
    dueDate: DateTime.now().add(const Duration(hours: 6)),
    frequencyLabel: 'Weekly',
  ),
  PlantCareTask(
    id: 'mist-fern',
    titleEn: 'Mist the Fern',
    titleAr: 'رش السرخس',
    descriptionEn: 'Lightly mist to keep humidity above 60%.',
    descriptionAr: 'قم برش خفيف للحفاظ على رطوبة فوق 60٪.',
    dueDate: DateTime.now().add(const Duration(days: 1, hours: 3)),
    frequencyLabel: 'Every 3 days',
  ),
  PlantCareTask(
    id: 'rotate-snake',
    titleEn: 'Rotate Snake Plant',
    titleAr: 'دوّر سانسيفيريا',
    descriptionEn: 'Rotate 90° for even growth near window.',
    descriptionAr: 'دوّر النبات 90° لنمو متوازن قرب النافذة.',
    dueDate: DateTime.now().add(const Duration(hours: 30)),
    frequencyLabel: 'Bi-weekly',
  ),
  PlantCareTask(
    id: 'fertilize-pothos',
    titleEn: 'Fertilize Pothos',
    titleAr: 'سمّد البوتس',
    descriptionEn: 'Use balanced liquid fertilizer, dilute to 1/2.',
    descriptionAr: 'استخدم سماداً سائلاً متوازناً بنسبة تخفيف 50٪.',
    dueDate: DateTime.now().add(const Duration(days: 3)),
    frequencyLabel: 'Monthly',
  ),
];
