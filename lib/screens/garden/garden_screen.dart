import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../app.dart';
import '../../localization/app_localizations.dart';
import '../../models/owned_plant.dart';

class GardenScreen extends StatelessWidget {
  const GardenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.t('garden')),
        actions: [
          IconButton(
            icon: const Icon(Icons.waves_outlined),
            onPressed: () => Navigator.pushNamed(context, '/care/calendar'),
            tooltip: t.t('care_calendar'),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: app.gardenController.garden,
        builder: (context, garden, _) {
          if (garden.isEmpty) {
            return _emptyState(context, t);
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _summary(context, t, garden),
              const SizedBox(height: 16),
              ...garden
                  .map((p) => _GardenCard(
                        plant: p,
                        localeCode: app.localeController.locale.languageCode,
                        onWater: () => app.gardenController.markWatered(p.plantId),
                        onHealthChange: (health) =>
                            app.gardenController.updateHealth(p.plantId, health),
                        onRemove: () => app.gardenController.remove(p.plantId),
                      ))
                  .toList(),
            ],
          );
        },
      ),
    );
  }

  Widget _summary(BuildContext context, AppLocalizations t, List<OwnedPlant> garden) {
    final upcoming = garden..sort((a, b) => a.nextWatering.compareTo(b.nextWatering));
    final next = upcoming.first;
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: kElevationToShadow[2],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.t('garden_overview'), style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            t.t('garden_overview_body'),
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _statTile(
                context,
                label: t.t('owned_count'),
                value: garden.length.toString(),
                icon: Icons.eco,
              ),
              const SizedBox(width: 12),
              _statTile(
                context,
                label: t.t('next_watering'),
                value: _friendlyDate(next.nextWatering, t),
                icon: Icons.water_drop_outlined,
              ),
              const SizedBox(width: 12),
              _statTile(
                context,
                label: t.t('thriving'),
                value: garden
                    .where((p) => p.health == PlantHealth.thriving)
                    .length
                    .toString(),
                icon: Icons.favorite_outline,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.15, end: 0);
  }

  Widget _statTile(BuildContext context,
      {required String label, required String value, required IconData icon}) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(height: 8),
            Text(value, style: theme.textTheme.headlineSmall),
            Text(label, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context, AppLocalizations t) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_florist_outlined,
                size: 88, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(t.t('empty_garden_title'), style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              t.t('empty_garden_body'),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.pushNamed(context, '/main'),
              child: Text(t.t('go_to_catalog')),
            ).animate().scale(delay: 100.ms, duration: 250.ms),
          ],
        ),
      ),
    );
  }

  String _friendlyDate(DateTime date, AppLocalizations t) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    if (difference < 1) return t.t('today');
    if (difference == 1) return t.t('tomorrow');
    return '${difference}d';
  }
}

class _GardenCard extends StatelessWidget {
  final OwnedPlant plant;
  final String localeCode;
  final VoidCallback onWater;
  final void Function(PlantHealth) onHealthChange;
  final VoidCallback onRemove;

  const _GardenCard({
    required this.plant,
    required this.localeCode,
    required this.onWater,
    required this.onHealthChange,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: kElevationToShadow[1],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              plant.imageUrl,
              width: 96,
              height: 96,
              fit: BoxFit.cover,
            ),
          ).animate().fadeIn(duration: 250.ms).scale(begin: const Offset(0.9, 0.9)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        plant.displayName(localeCode),
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    PopupMenuButton<PlantHealth>(
                      onSelected: onHealthChange,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: PlantHealth.thriving,
                          child: Text(t.t('thriving')),
                        ),
                        PopupMenuItem(
                          value: PlantHealth.steady,
                          child: Text(t.t('steady')),
                        ),
                        PopupMenuItem(
                          value: PlantHealth.struggling,
                          child: Text(t.t('needs_attention')),
                        ),
                      ],
                      icon: const Icon(Icons.more_vert),
                    )
                  ],
                ),
                Text('${t.t('location')}: ${plant.location}',
                    style: theme.textTheme.bodyMedium),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _chip(context, t.t('next_watering'), _friendlyDate(plant.nextWatering, t)),
                    _chip(context, t.t('last_watered'), _friendlyDate(plant.lastWatered, t)),
                    _healthChip(context, t),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    FilledButton.icon(
                      onPressed: onWater,
                      icon: const Icon(Icons.water_drop_outlined),
                      label: Text(t.t('mark_watered')),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: onRemove,
                      icon: const Icon(Icons.delete_outline),
                      label: Text(t.t('remove')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).moveY(begin: 12, end: 0);
  }

  Widget _chip(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: theme.textTheme.bodySmall),
          const SizedBox(width: 6),
          Text(value, style: theme.textTheme.labelLarge),
        ],
      ),
    );
  }

  Widget _healthChip(BuildContext context, AppLocalizations t) {
    final theme = Theme.of(context);
    Color color;
    String label;
    switch (plant.health) {
      case PlantHealth.thriving:
        color = Colors.green;
        label = t.t('thriving');
        break;
      case PlantHealth.steady:
        color = Colors.orange;
        label = t.t('steady');
        break;
      case PlantHealth.struggling:
        color = Colors.red;
        label = t.t('needs_attention');
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite, color: color, size: 16),
          const SizedBox(width: 6),
          Text(label, style: theme.textTheme.labelLarge?.copyWith(color: color)),
        ],
      ),
    );
  }

  String _friendlyDate(DateTime date, AppLocalizations t) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    if (difference < 1) return t.t('today');
    if (difference == 1) return t.t('tomorrow');
    if (difference == -1) return t.t('yesterday');
    return difference > 0 ? '${difference}d' : '${difference.abs()}d ago';
  }
}
