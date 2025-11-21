import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';
import '../../app.dart';
import '../../data/mock_plants.dart';
import '../../localization/app_localizations.dart';
import '../../widgets/plant_card.dart';
import '../../widgets/primary_button.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = AppLocalizations.of(context);
    final heroPlant = mockPlants.first;
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
                      Text(heroPlant.nameEn,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: Theme.of(context).colorScheme.primary)),
                      const SizedBox(height: 8),
                      Text(heroPlant.shortDescriptionEn),
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
          Text('Categories', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              Chip(label: const Text('Indoor'), avatar: const Icon(IconlyLight.home)),
              Chip(label: const Text('Outdoor'), avatar: const Icon(IconlyLight.location)),
              Chip(label: const Text('Flowers'), avatar: const Icon(IconlyLight.category)),
              Chip(label: const Text('Tools'), avatar: const Icon(IconlyLight.paper)),
            ],
          ),
          const SizedBox(height: 16),
          Text('Featured', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          SizedBox(
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
          ),
        ],
      ),
    );
  }

  void _showAiInfo(BuildContext context, plant) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('AI Insights (mock)'),
            SizedBox(height: 8),
            Text('Future AI tips will appear here with personalized advice.'),
          ],
        ),
      ),
    );
  }
}
