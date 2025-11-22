import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';
import '../../app.dart';
import '../../data/mock_plants.dart';
import '../../localization/app_localizations.dart';
import '../../models/plant.dart';
import '../../models/app_notification.dart';
import '../../models/plant_care_task.dart';
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
          Row(
            children: [
              Expanded(
                child: Text('${t.t('welcome')}, ${app.authController.displayName}',
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              ValueListenableBuilder<List<AppNotification>>(
                valueListenable: app.notificationsController.notifications,
                builder: (context, notifications, _) {
                  final unread = notifications.where((n) => !n.read).length;
                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(IconlyLight.notification),
                        onPressed: () => Navigator.pushNamed(context, '/notifications'),
                      ),
                      if (unread > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Text('$unread',
                                style: const TextStyle(color: Colors.white, fontSize: 10)),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
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
          _quickActions(context, app, t),
          const SizedBox(height: 16),
          _recentlyViewed(context, app, locale, t),
          const SizedBox(height: 16),
          _careStrip(context, app),
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

  Widget _quickActions(BuildContext context, AppScope app, AppLocalizations t) {
    Widget card({required VoidCallback onTap, required IconData icon, required String title, required String subtitle}) {
      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 8),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ).animate().slide(begin: const Offset(0, 0.05)).fadeIn(duration: 220.ms),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            card(
              onTap: () => Navigator.pushNamed(context, '/guides'),
              icon: IconlyBold.paper,
              title: t.t('explore_guides'),
              subtitle: t.t('micro_lessons'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/rewards'),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(IconlyBold.star, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 6),
                          ValueListenableBuilder<int>(
                            valueListenable: app.rewardsController.points,
                            builder: (context, points, _) => Text('$points ${t.t('pts')}',
                                style: Theme.of(context).textTheme.bodySmall),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(t.t('view_rewards'), style: Theme.of(context).textTheme.titleMedium),
                      Text(t.t('reward_hint'), style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ).animate().slide(begin: const Offset(0, 0.05)).fadeIn(duration: 220.ms),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            card(
              onTap: () => Navigator.pushNamed(context, '/bundles'),
              icon: IconlyBold.bag,
              title: t.t('shop_bundles'),
              subtitle: t.t('bundle_subtitle'),
            ),
            const SizedBox(width: 10),
            card(
              onTap: () => Navigator.pushNamed(context, '/inspiration'),
              icon: IconlyBold.video,
              title: t.t('get_inspired'),
              subtitle: t.t('inspiration_subtitle'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/care/calendar'),
            icon: const Icon(IconlyLight.calendar),
            label: Text(t.t('calendar_shortcut')),
          ).animate().fadeIn(duration: 200.ms),
        )
      ],
    );
  }

  Widget _recentlyViewed(
      BuildContext context, AppScope app, Locale locale, AppLocalizations t) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: app.recentController.ids,
      builder: (context, ids, _) {
        if (ids.isEmpty) return const SizedBox.shrink();
        final plants = ids
            .map((id) => app.catalogController.findById(id))
            .whereType<Plant>()
            .toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                children: [
                  Expanded(
                  child: Text(t.t('recently_viewed'),
                      style: Theme.of(context).textTheme.titleMedium),
                  ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/recent'),
                  child: Text(t.t('open')),
                )
              ],
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: plants.length,
                itemBuilder: (context, index) {
                  final plant = plants[index];
                  return SizedBox(
                    width: 180,
                    child: PlantCard(
                      plant: plant,
                      onTap: () => Navigator.pushNamed(context, '/plant/${plant.id}'),
                    )
                        .animate()
                        .fadeIn(delay: (index * 70).ms)
                        .slideX(begin: locale.languageCode == 'ar' ? 0.1 : -0.1);
                },
              ),
            ),
          ],
        );
      },
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

  Widget _careStrip(BuildContext context, AppScope app) {
    final t = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    return ValueListenableBuilder<List<PlantCareTask>>(
      valueListenable: app.careController.tasks,
      builder: (context, tasks, _) {
        if (tasks.isEmpty) return const SizedBox.shrink();
        final sorted = [...tasks];
        sorted.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        final next = sorted.first;
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(IconlyBold.calendar, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.t('up_next'), style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(next.localizedTitle(locale)),
                    Text(t.t('due_in_hours').replaceFirst('{hours}', next.dueDate.difference(DateTime.now()).inHours.toString()),
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(IconlyLight.arrow_right_circle),
                onPressed: () => Navigator.pushNamed(context, '/care'),
              ),
            ],
          ),
        ).animate().shimmer(duration: 1200.ms, color: Theme.of(context).colorScheme.primary.withOpacity(0.2));
      },
    );
  }
}
