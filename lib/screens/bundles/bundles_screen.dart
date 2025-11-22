import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';
import '../../app.dart';
import '../../data/mock_bundles.dart';
import '../../data/mock_plants.dart';
import '../../localization/app_localizations.dart';
import '../../models/plant.dart';
import '../../models/plant_bundle.dart';
import '../../widgets/primary_button.dart';

class BundlesScreen extends StatelessWidget {
  const BundlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.t('bundles'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _hero(context, t),
          const SizedBox(height: 16),
          ...mockBundles
              .map((bundle) => _bundleCard(context, bundle, locale, t))
              .toList(),
        ],
      ),
    );
  }

  Widget _hero(BuildContext context, AppLocalizations t) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.16),
            Theme.of(context).colorScheme.primary.withOpacity(0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.t('bundle_headline'), style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(t.t('bundle_subtitle'), style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    _chip(context, t.t('great_value')),
                    _chip(context, t.t('curated_sets')),
                  ],
                ),
              ],
            ),
          ),
          Icon(IconlyBold.bag, size: 48, color: Theme.of(context).colorScheme.primary)
              .animate()
              .shake(duration: 1.seconds)
              .then()
              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _chip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelMedium),
    );
  }

  Widget _bundleCard(BuildContext context, PlantBundle bundle, String locale, AppLocalizations t) {
    final app = AppScope.of(context);
    final plants = bundle.plantIds
        .map((id) => mockPlants.firstWhere((p) => p.id == id, orElse: () => mockPlants.first))
        .toList();
    final price = bundle.price.toStringAsFixed(2);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(bundle.imageUrl, height: 170, fit: BoxFit.cover)
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .scale(begin: const Offset(0.97, 0.97), duration: 300.ms),
            ),
            const SizedBox(height: 10),
            Text(bundle.localizedTitle(locale), style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(bundle.localizedDescription(locale)),
            const SizedBox(height: 8),
            Text(bundle.highlight, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: plants
                  .map((p) => _plantPill(context, p.localizedName(Locale(locale)), p.price))
                  .toList(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('${t.t('bundle_price')} $price', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                PrimaryButton(
                  label: t.t('add_bundle'),
                  onPressed: () {
                    for (final plant in plants) {
                      app.cartController.addToCart(plant);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(t.t('bundle_added'))),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    ).animate().slideY(begin: 0.05, duration: 260.ms).fadeIn(duration: 260.ms);
  }

  Widget _plantPill(BuildContext context, String name, double price) {
    return Chip(
      avatar: Icon(IconlyLight.tick_square, color: Theme.of(context).colorScheme.primary, size: 18),
      label: Text('$name · ${price.toStringAsFixed(0)}'),
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
    );
  }
}
