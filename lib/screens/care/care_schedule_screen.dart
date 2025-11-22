import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';
import '../../app.dart';
import '../../controllers/care_controller.dart';
import '../../localization/app_localizations.dart';
import '../../models/plant_care_task.dart';
import '../../widgets/primary_button.dart';

class CareScheduleScreen extends StatelessWidget {
  const CareScheduleScreen({super.key});

  String _dueLabel(BuildContext context, PlantCareTask task) {
    final t = AppLocalizations.of(context);
    final now = DateTime.now();
    final diff = task.dueDate.difference(now);
    if (diff.inHours <= 0) return t.t('due_now');
    if (diff.inHours < 24) {
      return t.t('due_in_hours').replaceFirst('{hours}', diff.inHours.toString());
    }
    final days = (diff.inHours / 24).ceil();
    return t.t('due_in_days').replaceFirst('{days}', days.toString());
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final controller = app.careController;
    final t = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.t('care_schedule')),
        actions: [
          IconButton(
            icon: const Icon(IconlyLight.notification),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
        ],
      ),
      body: ValueListenableBuilder<List<PlantCareTask>>(
        valueListenable: controller.tasks,
        builder: (context, tasks, _) {
          if (tasks.isEmpty) {
            return Center(child: Text(t.t('care_empty')));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _heroCard(context, t),
              const SizedBox(height: 16),
              ...tasks
                  .map((task) => _taskTile(context, app, task, controller, locale))
                  .toList(),
            ],
          );
        },
      ),
    );
  }

  Widget _heroCard(BuildContext context, AppLocalizations t) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.15),
            Theme.of(context).colorScheme.primary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.t('care_headline'), style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(t.t('care_subtitle')),
                const SizedBox(height: 12),
                PrimaryButton(
                  label: t.t('view_up_next'),
                  onPressed: () => Navigator.pushNamed(context, '/notifications'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(IconlyBold.activity, size: 54, color: Theme.of(context).colorScheme.primary),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms).slide(begin: const Offset(0, 0.1));
  }

  Widget _taskTile(
      BuildContext context, AppScope app, PlantCareTask task, CareController controller, Locale locale) {
    final t = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListTile(
        leading: AnimatedScale(
          duration: 180.ms,
          scale: task.completed ? 1.05 : 1,
          child: Checkbox(
            value: task.completed,
            onChanged: (_) async {
              await controller.toggleComplete(task.id);
              if (!task.completed) {
                await app.rewardsController.addPoints(12);
              }
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        title: Text(task.localizedTitle(locale)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.localizedDescription(locale)),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(IconlyLight.time_circle, size: 16),
                const SizedBox(width: 6),
                Text(_dueLabel(context, task)),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(task.frequencyLabel),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(IconlyLight.more_circle),
              onPressed: () => controller.postpone(task.id),
              tooltip: t.t('snooze'),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 250.ms).slide(begin: const Offset(0, 0.08));
  }
}
