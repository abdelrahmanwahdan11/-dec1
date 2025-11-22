import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';
import '../../app.dart';
import '../../data/mock_plants.dart';
import '../../localization/app_localizations.dart';
import '../../models/plant.dart';
import '../../widgets/plant_card.dart';
import '../../widgets/primary_button.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = AppLocalizations.of(context);
    final heroPlant = mockPlants.first;
    final locale = Localizations.localeOf(context);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('${t.t('welcome')}, ${app.authController.displayName}',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(heroPlant.localizedName(locale),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: Theme.of(context).colorScheme.primary)),
                      const SizedBox(height: 8),
                      Text(heroPlant.localizedShortDescription(locale)),
                      const SizedBox(height: 12),
                      PrimaryButton(
                        label: t.t('add_to_cart'),
                        onPressed: () => app.cartController.addToCart(heroPlant),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Hero(
                    tag: 'plant-${heroPlant.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(heroPlant.imageUrl, height: 200, fit: BoxFit.cover)
                          .animate()
                          .slide(begin: const Offset(0.1, 0), duration: 400.ms),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(t.t('categories'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _categoryChip(context, t.t('indoor'), IconlyLight.home, () {
                app.catalogController.setCategory(PlantCategory.indoor);
                Navigator.pushNamed(context, '/catalog');
              }),
              _categoryChip(context, t.t('outdoor'), IconlyLight.location, () {
                app.catalogController.setCategory(PlantCategory.outdoor);
                Navigator.pushNamed(context, '/catalog');
              }),
              _categoryChip(context, t.t('flowers'), IconlyLight.category, () {
                app.catalogController.setCategory(PlantCategory.flower);
                Navigator.pushNamed(context, '/catalog');
              }),
              _categoryChip(context, t.t('tools'), IconlyLight.paper, () {
                app.catalogController.setCategory(PlantCategory.tool);
                Navigator.pushNamed(context, '/catalog');
              }),
            ],
          ),
          const SizedBox(height: 16),
          Text(t.t('featured'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ValueListenableBuilder<Set<String>>(
            valueListenable: app.favoritesController.favorites,
            builder: (context, favorites, _) {
              return SizedBox(
                height: 320,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: mockPlants.length,
                  itemBuilder: (context, index) {
                    final plant = mockPlants[index];
                    final compared = app.compareController.compared.value
                        .any((element) => element.id == plant.id);
                    return PlantCard(
                      plant: plant,
                      compared: compared,
                      favorite: favorites.contains(plant.id),
                      onFavoriteToggle: () async {
                        await app.favoritesController.toggle(plant);
                        final added = app.favoritesController.isFavorite(plant.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(added ? t.t('added_favorite') : t.t('removed_favorite'))),
                        );
                      },
                      onAddToCart: () {
                        app.cartController.addToCart(plant);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('${plant.nameEn} added')));
                      },
                      onCompare: () => app.compareController.toggle(plant),
                      onAiInfo: () => _showAiInfo(context, plant),
                      onTap: () => Navigator.pushNamed(context, '/plant/${plant.id}'),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAiInfo(BuildContext context, plant) {
    final t = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.t('ai_mock_title')),
            const SizedBox(height: 8),
            Text(t.t('ai_mock_body')),
          ],
        ),
      ),
    );
  }

  Widget _categoryChip(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return ActionChip(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
