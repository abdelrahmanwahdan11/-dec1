import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SkeletonPlantCard extends StatelessWidget {
  const SkeletonPlantCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(24),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(duration: 1200.ms),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 14, width: 120, color: Colors.grey.shade300)
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .shimmer(duration: 1100.ms),
                const SizedBox(height: 8),
                Container(height: 12, width: 80, color: Colors.grey.shade300)
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .shimmer(duration: 1100.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
