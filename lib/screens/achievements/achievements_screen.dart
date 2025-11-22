import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../app.dart';
import '../../localization/app_localizations.dart';
import '../../models/achievement.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.t('achievements'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.t('achievements_subtitle'), style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: app.achievementsController.achievements.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = app.achievementsController.achievements[index];
                  return ValueListenableBuilder(
                    valueListenable: app.achievementsController.completed,
                    builder: (context, completed, _) {
                      final isDone = completed.contains(item.id);
                      return _AchievementCard(
                        achievement: item,
                        isDone: isDone,
                        localeCode: locale.languageCode,
                        onToggle: () => app.achievementsController.toggleComplete(item),
                      ).animate().fadeIn(duration: 240.ms).slide(begin: Offset(0, 0.05 * (index + 1)));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({
    required this.achievement,
    required this.isDone,
    required this.localeCode,
    required this.onToggle,
  });

  final Achievement achievement;
  final bool isDone;
  final String localeCode;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 200.ms,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isDone
            ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4)
            : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        border: Border.all(
          color: isDone
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).dividerColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(achievement.icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  localeCode == 'ar' ? achievement.titleAr : achievement.titleEn,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              AnimatedSwitcher(
                duration: 200.ms,
                child: isDone
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.radio_button_unchecked),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            localeCode == 'ar' ? achievement.descriptionAr : achievement.descriptionEn,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Chip(
                label: Text('+${achievement.points} ${AppLocalizations.of(context)!.t('pts')}'),
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: onToggle,
                child: Text(isDone
                    ? AppLocalizations.of(context)!.t('mark_incomplete')
                    : AppLocalizations.of(context)!.t('mark_done')),
              ),
              const Spacer(),
              Icon(Icons.local_fire_department,
                  color: isDone
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary),
            ],
          ),
        ],
      ),
    );
  }
}
