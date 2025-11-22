import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../app.dart';
import '../../controllers/membership_controller.dart';
import '../../localization/app_localizations.dart';
import '../../models/membership_perk.dart';

class MembershipScreen extends StatelessWidget {
  const MembershipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = AppLocalizations.of(context);
    final controller = app.membershipController;
    final locale = Localizations.localeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.t('membership')),
      ),
      body: ValueListenableBuilder(
        valueListenable: controller.status,
        builder: (context, status, _) {
          final progress = (status.points / status.nextTierAt).clamp(0.0, 1.0);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _tierHeader(context, t, status, progress),
              const SizedBox(height: 12),
              _perkCarousel(context, t, locale, controller, status.perks),
              const SizedBox(height: 12),
              _activityCard(context, t, controller),
            ],
          );
        },
      ),
    );
  }

  Widget _tierHeader(BuildContext context, AppLocalizations t, dynamic status, double progress) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.12),
            Theme.of(context).colorScheme.primary.withOpacity(0.28),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.workspace_premium_outlined, size: 32),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.t('membership_overview'), style: Theme.of(context).textTheme.titleMedium),
                  Text(t.t('membership_cta'), style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${t.t('current_tier')}: ${status.tier}',
                      style: Theme.of(context).textTheme.titleLarge),
                  Text('${t.t('points')}: ${status.points}')
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                ),
                child: Text(t.t('unlock_perks')),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              color: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
            ),
          ).animate().fadeIn().scaleX(alignment: Alignment.centerLeft, duration: 400.ms),
          const SizedBox(height: 6),
          Text('${t.t('next_tier')} ${status.nextTierAt}'),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.05);
  }

  Widget _perkCarousel(BuildContext context, AppLocalizations t, Locale locale,
      MembershipController controller, List<MembershipPerk> perks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(t.t('perks'), style: Theme.of(context).textTheme.titleMedium),
            TextButton(
              onPressed: () => controller.addPoints(25),
              child: Text(t.t('earn_more')),
            )
          ],
        ),
        const SizedBox(height: 8),
        ...perks.map(
          (perk) => _perkTile(context, locale, controller, perk),
        ),
      ],
    );
  }

  Widget _perkTile(BuildContext context, Locale locale, MembershipController controller, MembershipPerk perk) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
            ),
            child: Icon(perk.claimed ? Icons.check : Icons.card_giftcard,
                color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(perk.localizedTitle(locale), style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(perk.localizedDescription(locale)),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: perk.claimed ? null : () => controller.claimPerk(perk.id),
                    child: Text(perk.claimed ? '✔' : AppLocalizations.of(context).t('claim_perk')),
                  ).animate(target: perk.claimed ? 0 : 1).scale(begin: const Offset(0.96, 0.96), end: const Offset(1, 1)),
                ),
              ],
            ),
          )
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.04);
  }

  Widget _activityCard(BuildContext context, AppLocalizations t, MembershipController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.t('membership_activity'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(t.t('membership_activity_hint')),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              ActionChip(
                label: Text(t.t('care_win')),
                onPressed: () => controller.addPoints(10),
              ),
              ActionChip(
                label: Text(t.t('orders')),
                onPressed: () => controller.addPoints(15),
              ),
              ActionChip(
                label: Text(t.t('favorites')),
                onPressed: () => controller.addPoints(5),
              ),
            ],
          ).animate().fadeIn().slideY(begin: 0.03),
        ],
      ),
    );
  }
}
