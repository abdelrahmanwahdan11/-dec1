import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/plant.dart';

class Plant3DCard extends StatelessWidget {
  final Plant plant;
  final VoidCallback? onTap;
  const Plant3DCard({super.key, required this.plant, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 0),
        duration: const Duration(milliseconds: 400),
        builder: (context, value, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(value),
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    plant.imageUrl,
                    fit: BoxFit.cover,
                  ).animate().fadeIn(duration: 350.ms).scale(),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                plant.nameEn,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text('\$${plant.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary)),
            ],
          ),
        ),
      ),
    );
  }
}
