import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';
import '../models/plant.dart';

class PlantCard extends StatelessWidget {
  final Plant plant;
  final VoidCallback? onAddToCart;
  final VoidCallback? onTap;
  final VoidCallback? onCompare;
  final VoidCallback? onAiInfo;
  final bool compared;

  const PlantCard({
    super.key,
    required this.plant,
    this.onAddToCart,
    this.onTap,
    this.onCompare,
    this.onAiInfo,
    this.compared = false,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'plant-${plant.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(plant.imageUrl, fit: BoxFit.cover),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.localizedName(locale),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text('\$${plant.price.toStringAsFixed(2)}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: onAddToCart,
                        icon: const Icon(IconlyBold.buy),
                      ).animate().scale(),
                      IconButton(
                        onPressed: onCompare,
                        icon: Icon(compared ? IconlyBold.show : IconlyLight.show),
                        color: compared ? Theme.of(context).colorScheme.primary : null,
                      ),
                      IconButton(
                        onPressed: onAiInfo,
                        icon: const Icon(IconlyLight.info_circle),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 350.ms).slide(),
    );
  }
}
