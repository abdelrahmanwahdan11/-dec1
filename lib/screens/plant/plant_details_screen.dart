import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';
import '../../app.dart';
import '../../data/mock_plants.dart';
import '../../models/plant.dart';
import '../../widgets/primary_button.dart';

class PlantDetailsScreen extends StatefulWidget {
  final String plantId;
  const PlantDetailsScreen({super.key, required this.plantId});

  @override
  State<PlantDetailsScreen> createState() => _PlantDetailsScreenState();
}

class _PlantDetailsScreenState extends State<PlantDetailsScreen> {
  bool flipped = false;

  @override
  Widget build(BuildContext context) {
    final plant = mockPlants.firstWhere((p) => p.id == widget.plantId);
    final app = AppScope.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAiInfo(context, plant),
        child: const Icon(IconlyLight.info_circle),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            GestureDetector(
              onTap: () => setState(() => flipped = !flipped),
              child: Hero(
                tag: 'plant-${plant.id}',
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(flipped ? pi : 0),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(plant.imageUrl, fit: BoxFit.cover),
                        ),
                        if (flipped)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withOpacity(0.55),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Text(
                                    plant.longDescriptionEn,
                                    style:
                                        const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plant.nameEn, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text('\$${plant.price.toStringAsFixed(2)}',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Theme.of(context).colorScheme.primary)),
                  const SizedBox(height: 12),
                  Text(plant.shortDescriptionEn),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        _propRow(IconlyLight.arrow_down_circle, 'Height', plant.heightRange),
                        _propRow(IconlyLight.sun, 'Temp', plant.temperatureRange),
                        _propRow(IconlyLight.activity, 'Humidity', plant.humidity),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          label: 'Add to Cart',
                          onPressed: () => app.cartController.addToCart(plant),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(IconlyBold.show),
                        onPressed: () => app.compareController.toggle(plant),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _propRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(title),
          const Spacer(),
          Text(value),
        ],
      ),
    );
  }

  void _openAiInfo(BuildContext context, Plant plant) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('AI Info for ${plant.nameEn}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const Text('Mock insights about plant care and styling. No API calls are executed.'),
          ],
        ),
      ),
    );
  }
}
