import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../app.dart';
import '../../models/plant.dart';
import '../../widgets/plant_card.dart';
import '../../localization/app_localizations.dart';

class RecentlyViewedScreen extends StatelessWidget {
  const RecentlyViewedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final l10n = AppLocalizations.of(context);
    final catalog = scope.catalogController;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('recently_viewed'))),
      body: ValueListenableBuilder<List<String>>(
        valueListenable: scope.recentController.ids,
        builder: (context, ids, _) {
          if (ids.isEmpty) {
            return Center(
              child: Text(
                l10n.t('empty_recent'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ).animate().fadeIn().slideY(begin: 0.1),
            );
          }
          final plants = ids
              .map((id) => catalog.findById(id))
              .whereType<Plant>()
              .toList();
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.78,
            ),
            itemCount: plants.length,
            itemBuilder: (context, index) {
              final plant = plants[index];
              return PlantCard(plant: plant)
                  .animate()
                  .fadeIn(delay: (index * 80).ms)
                  .scale(begin: const Offset(0.95, 0.95));
            },
          );
        },
      ),
    );
  }
}
