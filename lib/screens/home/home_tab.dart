import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';
import '../../app.dart';
import '../../data/mock_plants.dart';
import '../../data/mock_challenges.dart';
import '../../localization/app_localizations.dart';
import '../../models/plant.dart';
import '../../models/app_notification.dart';
import '../../models/plant_care_task.dart';
import '../../models/journal_entry.dart';
import '../../models/plant_event.dart';
import '../../models/gallery_item.dart';
import '../../models/owned_plant.dart';
import '../../theme/app_theme.dart';
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
          _savingsStrip(context, app, t),
          const SizedBox(height: 16),
          _updatesBanner(context, app, t),
          const SizedBox(height: 16),
          _eventsPeek(context, app, t, locale.languageCode),
          const SizedBox(height: 16),
          _galleryPeek(context, app, t, locale.languageCode),
          const SizedBox(height: 16),
          _insightsStrip(context, app, t),
          const SizedBox(height: 16),
          _quizStrip(context, app, t),
          const SizedBox(height: 16),
          _challengesStrip(context, app, t),
          const SizedBox(height: 16),
          _gardenPeek(context, app, locale.languageCode, t),
          const SizedBox(height: 16),
          _journalTeaser(context, app, locale, t),
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
        const SizedBox(height: 10),
        Row(
          children: [
            card(
              onTap: () => Navigator.pushNamed(context, '/diagnostics'),
              icon: IconlyBold.shield_done,
              title: t.t('diagnostics'),
              subtitle: t.t('diagnostics_hint'),
            ),
            const SizedBox(width: 10),
            card(
              onTap: () => Navigator.pushNamed(context, '/gifting'),
              icon: Icons.card_giftcard,
              title: t.t('gifting_center'),
              subtitle: t.t('gifting_hint'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            card(
              onTap: () => Navigator.pushNamed(context, '/garden'),
              icon: Icons.local_florist_outlined,
              title: t.t('garden'),
              subtitle: t.t('garden_overview'),
            ),
            const SizedBox(width: 10),
            card(
              onTap: () => Navigator.pushNamed(context, '/care/calendar'),
              icon: IconlyBold.calendar,
              title: t.t('care_calendar'),
              subtitle: t.t('calendar_shortcut'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _savingsStrip(BuildContext context, AppScope app, AppLocalizations t) {
    final locale = Localizations.localeOf(context);
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/coupons'),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.18),
                  Theme.of(context).colorScheme.primary.withOpacity(0.08),
                ]),
              ),
              child: ValueListenableBuilder(
                valueListenable: app.promoController.appliedCoupon,
                builder: (context, coupon, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.t('coupon_center'), style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        coupon == null
                            ? t.t('browse_coupons')
                            : coupon.localizedTitle(locale),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/coupons'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(coupon?.percentageLabel() ?? t.t('apply_now')),
                      ),
                    ],
                  ).animate().fadeIn().slideX(begin: -0.04);
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/referrals'),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.45),
              ),
              child: ValueListenableBuilder<int>(
                valueListenable: app.referralController.rewards,
                builder: (context, rewards, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.t('referrals'), style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(t.t('invite_hint'), style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(IconlyBold.star, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 6),
                          Text('$rewards ${t.t('pts')}'),
                        ],
                      ),
                    ],
                  ).animate().fadeIn().slideX(begin: 0.04);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _updatesBanner(BuildContext context, AppScope app, AppLocalizations t) {
    final locale = Localizations.localeOf(context);
    return ValueListenableBuilder<DateTime?>(
      valueListenable: app.changelogController.lastSeenDate,
      builder: (context, _, __) {
        final update = app.changelogController.updates.value.first;
        final unread = app.changelogController.hasUnread;
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/updates');
            app.changelogController.markAllSeen();
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.12),
                  Theme.of(context).colorScheme.primary.withOpacity(0.08),
                ],
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(t.t('whats_new'), style: Theme.of(context).textTheme.titleMedium),
                          if (unread)
                            Container(
                              margin: const EdgeInsetsDirectional.only(start: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.errorContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(t.t('new'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(color: Theme.of(context).colorScheme.onErrorContainer)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(update.localizedTitle(locale.languageCode),
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 4),
                      Text(update.localizedDescription(locale.languageCode),
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.upgrade_outlined, color: Theme.of(context).colorScheme.primary),
              ],
            ),
          ).animate().fadeIn(duration: 240.ms).slideX(begin: -0.03),
        );
      },
    );
  }

  Widget _eventsPeek(
      BuildContext context, AppScope app, AppLocalizations t, String localeCode) {
    final events = app.eventsController.upcomingOnly().take(2).toList();
    if (events.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(t.t('events'), style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/events'),
              child: Text(t.t('view_all')),
            )
          ],
        ),
        const SizedBox(height: 6),
        ...events.map((event) {
          final isRsvped = app.eventsController.isRsvped(event.id);
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppThemeBuilder.cardShadow(Theme.of(context)),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(event.imageUrl, width: 70, height: 70, fit: BoxFit.cover)
                      .animate()
                      .scale(duration: 240.ms),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event.localizedTitle(localeCode),
                          style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 4),
                      Text(event.localizedLocation(localeCode),
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => app.eventsController.toggleRsvp(event.id),
                  icon: Icon(
                    isRsvped ? IconlyBold.calendar : IconlyLight.calendar,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              ],
            ),
          ).animate(delay: 80.ms).fadeIn(duration: 280.ms).slideX(begin: 0.05);
        })
      ],
    );
  }

  Widget _galleryPeek(
      BuildContext context, AppScope app, AppLocalizations t, String localeCode) {
    final gallery = app.galleryController.gallery.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(t.t('gallery'), style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/gallery'),
              child: Text(t.t('view_all')),
            )
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: gallery.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = gallery[index];
              final liked = app.galleryController.isLiked(item.id);
              return Container(
                width: 220,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppThemeBuilder.cardShadow(Theme.of(context)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(item.imageUrl,
                                  width: 90, height: 70, fit: BoxFit.cover)
                              .animate()
                              .scale(duration: 220.ms),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.localizedTitle(localeCode),
                                  style: Theme.of(context).textTheme.titleSmall),
                              const SizedBox(height: 4),
                              Text(item.localizedCaption(localeCode),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(t.t('gallery_hint'),
                            style: Theme.of(context).textTheme.bodySmall),
                        const Spacer(),
                        IconButton(
                          onPressed: () => app.galleryController.toggleLike(item.id),
                          icon: Icon(
                            liked ? IconlyBold.heart : IconlyLight.heart,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ).animate(delay: (index * 60).ms).fadeIn().slideX(begin: 0.08);
            },
          ),
        )
      ],
    );
  }

  Widget _insightsStrip(BuildContext context, AppScope app, AppLocalizations t) {
    final tasks = app.careController.tasks.value;
    final completed = tasks.where((task) => task.completed).length;
    final total = tasks.length;
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/insights'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.t('insights'), style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(t.t('insights_entry'), style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: total == 0 ? 0 : completed / total,
                    minHeight: 8,
                    color: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(IconlyBold.chart),
                  const SizedBox(height: 6),
                  Text('$completed/$total'),
                ],
              ),
            ),
          ],
        ),
      ).animate().slide(begin: const Offset(0, 0.04)).fadeIn(),
    );
  }

  Widget _quizStrip(BuildContext context, AppScope app, AppLocalizations t) {
    final total = app.quizController.questions.length;
    return ValueListenableBuilder(
      valueListenable: app.quizController.state,
      builder: (context, state, _) {
        final answered = state.answers.length;
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/quiz'),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.t('quizzes_title'),
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(t.t('quiz_subtitle'),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Theme.of(context).hintColor)),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: total == 0 ? 0 : answered / total,
                        minHeight: 8,
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceVariant,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  children: [
                    Chip(
                      label: Text(t.t('quiz_chip')),
                      backgroundColor:
                          Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    ),
                    const SizedBox(height: 6),
                    Text('$answered/$total',
                        style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn().slideX(begin: -0.06),
        );
      },
    );
  }

  Widget _challengesStrip(
      BuildContext context, AppScope app, AppLocalizations t) {
    return ValueListenableBuilder(
      valueListenable: app.challengesController.state,
      builder: (context, state, _) {
        final completed = mockChallenges
            .where((c) => state.isComplete(c.id, c.target))
            .length;
        final total = mockChallenges.length;
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/challenges'),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.4),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.t('challenges'),
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        t.t('challenge_subtitle'),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Theme.of(context).hintColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('$completed/$total'),
                    ),
                    const SizedBox(height: 6),
                    const Icon(Icons.bolt_rounded),
                  ],
                )
              ],
            ),
          ).animate().fadeIn().slideX(begin: 0.06),
        );
      },
    );
  }

  Widget _gardenPeek(BuildContext context, AppScope app, String localeCode, AppLocalizations t) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: theme.colorScheme.surface,
        boxShadow: AppThemeBuilder.cardShadow(theme),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(t.t('garden'), style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/garden'),
                child: Text(t.t('view_all')),
              )
            ],
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder<List<OwnedPlant>>(
            valueListenable: app.gardenController.garden,
            builder: (context, garden, _) {
              if (garden.isEmpty) {
                return Text(t.t('empty_garden_body'), style: theme.textTheme.bodyMedium);
              }
              return SizedBox(
                height: 170,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final plant = garden[index];
                    return Container(
                      width: 200,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: theme.colorScheme.surfaceVariant.withOpacity(0.6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(plant.imageUrl,
                                        width: 70, height: 70, fit: BoxFit.cover)
                                    .animate()
                                    .scale(duration: 220.ms, curve: Curves.easeOut),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(plant.displayName(localeCode),
                                        style: theme.textTheme.titleSmall,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 6),
                                    _healthPill(context, plant.health, t),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text('${t.t('next_watering')}: ${_relativeWatering(plant.nextWatering, t)}',
                              style: theme.textTheme.bodySmall),
                          Text('${t.t('last_watered')}: ${_relativeWatering(plant.lastWatered, t)}',
                              style: theme.textTheme.bodySmall),
                          const Spacer(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () => app.gardenController.markWatered(plant.plantId),
                              icon: const Icon(Icons.water_drop_outlined),
                              label: Text(t.t('mark_watered')),
                            ),
                          )
                        ],
                      ),
                    ).animate(delay: (index * 50).ms).fadeIn().slideX(begin: 0.05);
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemCount: garden.length,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _journalTeaser(
      BuildContext context, AppScope app, Locale locale, AppLocalizations t) {
    return ValueListenableBuilder<List<JournalEntry>>(
      valueListenable: app.journalController.entries,
      builder: (context, entries, _) {
        if (entries.isEmpty) return const SizedBox.shrink();
        final latest = entries.first;
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/journal'),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(latest.imageUrl, height: 80, width: 80, fit: BoxFit.cover)
                      .animate()
                      .fadeIn(duration: 260.ms)
                      .slide(begin: const Offset(0, 0.03)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.t('journal'), style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(latest.localizedTitle(locale.languageCode),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(latest.localizedNote(locale.languageCode),
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Chip(
                            label: Text(t.t(latest.mood)),
                            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                          ),
                          const SizedBox(width: 8),
                          Text(t.formatDate(latest.createdAt),
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ).animate().fadeIn(duration: 240.ms).slideX(begin: 0.03),
        );
      },
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

  Widget _healthPill(BuildContext context, PlantHealth health, AppLocalizations t) {
    Color color;
    String label;
    switch (health) {
      case PlantHealth.thriving:
        color = Colors.green;
        label = t.t('thriving');
        break;
      case PlantHealth.steady:
        color = Colors.orange;
        label = t.t('steady');
        break;
      case PlantHealth.struggling:
        color = Colors.red;
        label = t.t('needs_attention');
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite, color: color, size: 14),
          const SizedBox(width: 6),
          Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color)),
        ],
      ),
    );
  }

  String _relativeWatering(DateTime date, AppLocalizations t) {
    final now = DateTime.now();
    final diff = date.difference(now).inDays;
    if (diff == 0) return t.t('today');
    if (diff == 1) return t.t('tomorrow');
    if (diff == -1) return t.t('yesterday');
    return diff > 0 ? '${diff}d' : '${diff.abs()}d ago';
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
