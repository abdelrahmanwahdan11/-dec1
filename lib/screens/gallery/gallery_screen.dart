import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../app.dart';
import '../../localization/app_localizations.dart';
import '../../models/gallery_item.dart';
import '../../theme/app_theme.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = AppLocalizations.of(context);
    final locale = app.localeController.locale.languageCode;
    return Scaffold(
      appBar: AppBar(title: Text(t.t('gallery'))),
      body: ValueListenableBuilder<List<GalleryItem>>(
        valueListenable: app.galleryController.gallery,
        builder: (_, gallery, __) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: gallery.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (context, index) {
              final item = gallery[index];
              final liked = app.galleryController.isLiked(item.id);
              return _galleryCard(context, item, liked, locale, t)
                  .animate(delay: (index * 70).ms)
                  .fadeIn(duration: 300.ms)
                  .scale(begin: const Offset(0.96, 0.96));
            },
          );
        },
      ),
    );
  }

  Widget _galleryCard(BuildContext context, GalleryItem item, bool liked,
      String locale, AppLocalizations t) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppThemeBuilder.cardShadow(theme),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                  child: Image.network(item.imageUrl, width: double.infinity, fit: BoxFit.cover),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    backgroundColor: theme.colorScheme.surface.withOpacity(0.86),
                    child: Icon(liked ? IconlyBold.heart : IconlyLight.heart,
                        color: theme.colorScheme.primary),
                  ).animate().scale(duration: 220.ms),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.localizedTitle(locale), style: theme.textTheme.titleSmall),
                const SizedBox(height: 6),
                Text(item.localizedCaption(locale), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: item.tags
                      .map((tag) => Chip(
                            label: Text(tag),
                            visualDensity: VisualDensity.compact,
                          ).animate().fadeIn())
                      .toList(),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => AppScope.of(context).galleryController.toggleLike(item.id),
                      icon: Icon(liked ? IconlyBold.heart : IconlyLight.heart,
                          color: theme.colorScheme.primary),
                    ),
                    const Spacer(),
                    Text(t.t('tap_to_expand'), style: theme.textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
