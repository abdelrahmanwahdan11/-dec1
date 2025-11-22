import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../app.dart';
import '../../data/mock_insights.dart';
import '../../data/mock_orders.dart';
import '../../localization/app_localizations.dart';
import '../../models/mock_order.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  double _totalSpend(List<MockOrder> orders) =>
      orders.fold(0, (previousValue, element) => previousValue + element.total);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final app = AppScope.of(context);
    final orders = mockOrders;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.t('insights')),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(IconlyLight.close_square),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: app.rewardsController.points,
        builder: (context, points, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _impactHeader(context, t, app, points as int, orders),
              const SizedBox(height: 16),
              _streakRow(context, t, app),
              const SizedBox(height: 16),
              _charts(context, t),
              const SizedBox(height: 16),
              _activityList(context, t, app, orders),
              const SizedBox(height: 16),
              _highlights(context, t),
            ],
          );
        },
      ),
    );
  }

  Widget _impactHeader(BuildContext context, AppLocalizations t, AppScope app, int points, List<MockOrder> orders) {
    final favoritesCount = app.favoritesController.favorites.value.length;
    final recent = app.recentController.recent.value.length;
    final totalSpend = _totalSpend(orders).toStringAsFixed(2);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.15),
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.4),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(IconlyBold.chart),
              const SizedBox(width: 8),
              Text(t.t('impact_overview'), style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              Chip(label: Text('${t.t('orders')}: ${orders.length}')),
            ],
          ).animate().slide(begin: const Offset(0, 0.04)).fadeIn(),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _statPill(context, IconlyBold.discovery, '${t.t('total_spend')}: \$$totalSpend'),
              _statPill(context, IconlyBold.heart, '${t.t('favorites')}: $favoritesCount'),
              _statPill(context, IconlyBold.time_circle, '${t.t('recently_viewed')}: $recent'),
              _statPill(context, IconlyBold.star, '${t.t('pts')}: $points'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statPill(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }

  Widget _streakRow(BuildContext context, AppLocalizations t, AppScope app) {
    return ValueListenableBuilder(
      valueListenable: app.careController.tasks,
      builder: (context, tasks, _) {
        final completed = (tasks as List).where((task) => task.completed).length;
        final due = (tasks).length;
        final percent = due == 0 ? 0.0 : completed / due;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.t('care_streak'), style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(t.t('care_streak_body')),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(value: percent, minHeight: 12),
                    ),
                    const SizedBox(height: 8),
                    Text('${(percent * 100).round()}% ${t.t('care_completed')} ($completed/$due)'),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(IconlyBold.activity, size: 42, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(t.t('care_now_hint')),
                  ),
                ],
              ).animate().shake(duration: 500.ms),
            ],
          ),
        );
      },
    );
  }

  Widget _charts(BuildContext context, AppLocalizations t) {
    Widget bar(List<double> values, Color color, String title) {
      final maxValue = values.fold<double>(0, max);
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: values
                    .asMap()
                    .entries
                    .map(
                      (entry) => Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: maxValue == 0 ? 4 : (entry.value / maxValue) * 120,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ).animate().scaleY(begin: 0.1, duration: 350.ms, curve: Curves.easeOut),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 8),
              Text(t.t('week_view'), style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        bar(weeklyHydrationLiters, Theme.of(context).colorScheme.primary.withOpacity(0.8), t.t('hydration_chart')),
        const SizedBox(width: 10),
        bar(weeklySunHours, Theme.of(context).colorScheme.tertiary.withOpacity(0.8), t.t('sun_chart')),
      ],
    );
  }

  Widget _activityList(BuildContext context, AppLocalizations t, AppScope app, List<MockOrder> orders) {
    final locale = app.localeController.locale;
    final combined = <Widget>[];
    final favorites = app.favoritesController.favorites.value.length;
    combined.add(_activityTile(context, IconlyBold.tick_square, t.t('orders_count', {'count': orders.length.toString()}),
        '${t.t('total_spend')}: \$${_totalSpend(orders).toStringAsFixed(2)}'));
    combined.add(_activityTile(context, IconlyBold.bag_2, t.t('bundle_story'), t.t('restock_hint_body')));
    combined.add(_activityTile(
        context,
        IconlyBold.heart,
        t.t('favorites_count', {'count': favorites.toString()}),
        t.t('favorites_body')));
    if (app.recentController.recent.value.isNotEmpty) {
      final last = app.recentController.recent.value.first;
      combined.add(_activityTile(context, IconlyBold.time_circle, t.t('last_viewed', {'name': last.localizedName(locale)}),
          t.t('recent_prompt')));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.t('recent_activity'), style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...combined.map((e) => Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: e)),
      ],
    );
  }

  Widget _activityTile(BuildContext context, IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const Icon(IconlyLight.arrow_right_2),
        ],
      ),
    ).animate().slide(begin: const Offset(0, 0.02)).fadeIn();
  }

  Widget _highlights(BuildContext context, AppLocalizations t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.t('insight_highlights'), style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...insightHighlights.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(IconlyBold.info_square),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.t(item['titleKey']!), style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 6),
                      Text(t.t(item['bodyKey']!), style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms).slide(begin: const Offset(0, 0.04));
        }),
      ],
    );
  }
}
