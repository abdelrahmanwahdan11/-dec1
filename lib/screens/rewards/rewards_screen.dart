import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';
import '../../app.dart';
import '../../controllers/rewards_controller.dart';
import '../../localization/app_localizations.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.t('rewards')),
        actions: [
          IconButton(
            icon: const Icon(IconlyLight.notification),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _pointsCard(context, app, t),
            const SizedBox(height: 12),
            _badgeRow(context, app, t),
            const SizedBox(height: 16),
            Text(t.t('quick_actions'), style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _actionTile(context, IconlyBold.bookmark, t.t('finish_guide'), () async {
              await app.rewardsController.addPoints(6);
              await app.rewardsController.markAction('guide_finished');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.t('points_added'))));
            }),
            _actionTile(context, IconlyBold.calendar, t.t('complete_care'), () async {
              await app.rewardsController.addPoints(10);
              await app.rewardsController.markAction('care_completed');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.t('points_added'))));
            }),
            _actionTile(context, IconlyBold.heart, t.t('favorite_plant'), () async {
              await app.rewardsController.addPoints(4);
              await app.rewardsController.markAction('favorite_added');
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.t('points_added'))));
            }),
            const SizedBox(height: 16),
            Text(t.t('redeem'), style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _RedeemChip(label: t.t('free_delivery'), cost: 60, controller: app.rewardsController),
                _RedeemChip(label: t.t('pot_upgrade'), cost: 80, controller: app.rewardsController),
                _RedeemChip(label: t.t('surprise_seed'), cost: 40, controller: app.rewardsController),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _pointsCard(BuildContext context, AppScope app, AppLocalizations t) {
    return ValueListenableBuilder<int>(
      valueListenable: app.rewardsController.points,
      builder: (context, points, _) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.14),
                Theme.of(context).colorScheme.primary.withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.t('your_points'), style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text('$points', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: (points % 100) / 100,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(8),
                    ).animate().shimmer(duration: 1200.ms),
                    const SizedBox(height: 8),
                    Text(t.t('next_reward_hint')),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(IconlyBold.star, size: 56, color: Theme.of(context).colorScheme.primary)
                  .animate()
                  .scale(begin: const Offset(0.9, 0.9), duration: 350.ms),
            ],
          ),
        ).animate().fadeIn(duration: 250.ms).slide(begin: const Offset(0, 0.08));
      },
    );
  }

  Widget _badgeRow(BuildContext context, AppScope app, AppLocalizations t) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: app.rewardsController.badges,
      builder: (context, badges, _) {
        final badgeList = badges.toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.t('earned_badges'), style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (badgeList.isEmpty)
              Text(t.t('no_badges'))
            else
              Wrap(
                spacing: 10,
                children: badgeList
                    .map((b) => Chip(
                          avatar: const Icon(IconlyBold.tick_square, size: 16),
                          label: Text(b.replaceAll('_', ' ')),
                        )
                        .animate()
                        .scale(begin: const Offset(0.94, 0.94)))
                    .toList(),
              ),
            TextButton(
              onPressed: () => app.rewardsController.clearBadges(),
              child: Text(t.t('reset_badges')),
            ),
          ],
        );
      },
    );
  }

  Widget _actionTile(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 6)),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        trailing: const Icon(IconlyLight.arrow_right_circle),
        onTap: onTap,
      ),
    ).animate().fadeIn(duration: 200.ms).slide(begin: const Offset(0, 0.06));
  }
}

class _RedeemChip extends StatelessWidget {
  final String label;
  final int cost;
  final RewardsController controller;

  const _RedeemChip({required this.label, required this.cost, required this.controller});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return ValueListenableBuilder<int>(
      valueListenable: controller.points,
      builder: (context, points, _) {
        final affordable = points >= cost;
        return FilterChip(
          selected: false,
          avatar: const Icon(IconlyLight.ticket, size: 18),
          label: Text('$label • $cost'),
          onSelected: affordable
              ? (_) async {
                  await controller.redeem(cost);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(t.t('redeemed'))));
                }
              : null,
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(affordable ? 0.14 : 0.06),
        ).animate().scale(begin: const Offset(0.95, 0.95));
      },
    );
  }
}
