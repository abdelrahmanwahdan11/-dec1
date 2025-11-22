import 'package:flutter/material.dart';
import '../../app.dart';
import '../../data/mock_plants.dart';
import '../../localization/app_localizations.dart';
import '../../widgets/plant_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.t('favorites')),
        actions: [
          TextButton(
            onPressed: () => app.favoritesController.clear(),
            child: Text(t.t('clear')),
          )
        ],
      ),
      body: ValueListenableBuilder<Set<String>>(
        valueListenable: app.favoritesController.favorites,
        builder: (context, ids, _) {
          final items = mockPlants.where((p) => ids.contains(p.id)).toList();
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  t.t('empty_favorites'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.78,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final plant = items[index];
              return PlantCard(
                plant: plant,
                favorite: true,
                onFavoriteToggle: () => app.favoritesController.toggle(plant),
                onAddToCart: () => app.cartController.addToCart(plant),
                onTap: () => Navigator.pushNamed(context, '/plant/${plant.id}'),
                onCompare: () => app.compareController.toggle(plant),
              );
            },
          );
        },
      ),
    );
  }
}
