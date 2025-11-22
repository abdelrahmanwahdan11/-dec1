import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../app.dart';
import '../../localization/app_localizations.dart';
import '../../models/update_note.dart';

class UpdatesScreen extends StatelessWidget {
  const UpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.t('whats_new')),
        actions: [
          TextButton(
            onPressed: () => app.changelogController.markAllSeen(),
            child: Text(t.t('mark_all_read'), style: const TextStyle(color: Colors.white)),
          )
              .animate()
              .fadeIn(duration: 250.ms)
              .slideX(begin: 0.05),
        ],
      ),
      body: ValueListenableBuilder<List<UpdateNote>>(
        valueListenable: app.changelogController.updates,
        builder: (context, updates, _) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: updates.length,
            itemBuilder: (context, index) {
              final note = updates[index];
              return _updateCard(context, note, locale.languageCode)
                  .animate()
                  .fadeIn(duration: 250.ms, delay: (index * 60).ms)
                  .slide(begin: const Offset(0, 0.04));
            },
          );
        },
      ),
    );
  }

  Widget _updateCard(BuildContext context, UpdateNote note, String code) {
    final t = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Chip(
                  label: Text(note.version),
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(t.formatDate(note.date)),
                  backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(note.localizedTitle(code), style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(note.localizedDescription(code)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: note.tags
                  .map((tag) => Chip(
                        label: Text('#$tag'),
                        backgroundColor: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.18),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
