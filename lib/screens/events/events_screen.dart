import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../app.dart';
import '../../localization/app_localizations.dart';
import '../../models/plant_event.dart';
import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = AppLocalizations.of(context);
    final locale = app.localeController.locale.languageCode;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.t('events')), 
        actions: [
          ValueListenableBuilder<Set<String>>(
            valueListenable: app.eventsController.bookmarks,
            builder: (_, bookmarks, __) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Chip(
                label: Text(t.t('saved_count', params: {'count': bookmarks.length})),
                avatar: const Icon(IconlyLight.bookmark, size: 18),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _filters(context, app, t),
          const SizedBox(height: 12),
          ValueListenableBuilder<List<PlantEvent>>(
            valueListenable: app.eventsController.events,
            builder: (_, events, __) {
              final upcoming = events
                  .where((e) => e.date.isAfter(DateTime.now()))
                  .toList()
                ..sort((a, b) => a.date.compareTo(b.date));
              return Column(
                children: List.generate(upcoming.length, (index) {
                  final event = upcoming[index];
                  return _eventCard(context, event, locale, app, t)
                      .animate(delay: (index * 80).ms)
                      .fadeIn(duration: 350.ms)
                      .slideY(begin: 0.05, duration: 350.ms);
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _filters(BuildContext context, AppScope app, AppLocalizations t) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(IconlyLight.calendar, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.t('up_next'), style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(t.t('events_subtitle'), style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          ValueListenableBuilder<List<PlantEvent>>(
            valueListenable: app.eventsController.events,
            builder: (_, events, __) {
              final workshops = events.where((e) => e.isWorkshop).length;
              return Chip(label: Text(t.t('workshops_count', params: {'count': workshops}))).animate().scale();
            },
          ),
        ],
      ),
    );
  }

  Widget _eventCard(BuildContext context, PlantEvent event, String locale,
      AppScope app, AppLocalizations t) {
    final isRsvped = app.eventsController.isRsvped(event.id);
    final isSaved = app.eventsController.isBookmarked(event.id);
    final theme = Theme.of(context);
    final dateStr = '${event.date.day}/${event.date.month} • ${event.date.hour.toString().padLeft(2, '0')}:${event.date.minute.toString().padLeft(2, '0')}';
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppThemeBuilder.cardShadow(theme),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(event.imageUrl, height: 170, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: CircleAvatar(
                  backgroundColor: theme.colorScheme.surface.withOpacity(0.92),
                  child: IconButton(
                    icon: Icon(isSaved ? IconlyBold.bookmark : IconlyLight.bookmark, color: theme.colorScheme.primary),
                    onPressed: () => app.eventsController.toggleBookmark(event.id),
                  ),
                ),
              ),
              Positioned(
                left: 12,
                top: 12,
                child: Chip(label: Text(event.isWorkshop ? t.t('workshop') : t.t('tour'))),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.localizedTitle(locale), style: theme.textTheme.titleMedium),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(IconlyLight.calendar, size: 18),
                    const SizedBox(width: 6),
                    Text(dateStr),
                    const SizedBox(width: 10),
                    const Icon(IconlyLight.location, size: 18),
                    const SizedBox(width: 6),
                    Expanded(child: Text(event.localizedLocation(locale), overflow: TextOverflow.ellipsis)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(event.localizedDescription(locale)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(IconlyLight.info_square, size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: Text(event.localizedFocus(locale))),
                    ],
                  ),
                ).animate().shake(duration: 500.ms, delay: 200.ms),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        label: isRsvped ? t.t('rsvp_saved') : t.t('rsvp'),
                        onPressed: () => app.eventsController.toggleRsvp(event.id),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () => app.eventsController.toggleBookmark(event.id),
                      icon: Icon(isSaved ? IconlyBold.heart : IconlyLight.heart, color: theme.colorScheme.primary),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
