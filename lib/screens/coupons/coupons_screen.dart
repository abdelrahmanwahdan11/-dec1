import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';
import '../../app.dart';
import '../../localization/app_localizations.dart';
import '../../models/coupon.dart';

class CouponsScreen extends StatelessWidget {
  const CouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final subtotal = app.cartController.subtotal;
    return Scaffold(
      appBar: AppBar(title: Text(t.t('coupons'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder<Coupon?>(
              valueListenable: app.promoController.appliedCoupon,
              builder: (context, applied, _) {
                if (applied == null) return const SizedBox.shrink();
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(IconlyBold.ticket),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.t('applied_coupon').replaceFirst('{code}', applied.code),
                                style: Theme.of(context).textTheme.titleMedium),
                            Text(applied.localizedDescription(locale)),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: app.promoController.clear,
                        child: Text(t.t('remove')),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.05);
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: app.promoController.coupons.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final coupon = app.promoController.coupons[index];
                  final expired = coupon.isExpired;
                  return _CouponCard(
                    coupon: coupon,
                    expired: expired,
                    locale: locale,
                    onApply: () {
                      final success = app.promoController.apply(coupon, subtotal);
                      final key = app.promoController.lastError.value;
                      final message = success
                          ? t.t('coupon_applied')
                              .replaceFirst('{code}', coupon.code)
                              .replaceFirst('{value}', coupon.percentageLabel())
                          : t.t(key ?? 'invalid_coupon')
                              .replaceFirst('{min}', coupon.minSpend.toStringAsFixed(0));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    },
                  ).animate().fadeIn(delay: (index * 40).ms).slideX(begin: 0.08);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CouponCard extends StatelessWidget {
  final Coupon coupon;
  final bool expired;
  final Locale locale;
  final VoidCallback onApply;
  const _CouponCard({
    required this.coupon,
    required this.expired,
    required this.locale,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                child: const Icon(IconlyBold.ticket),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(coupon.localizedTitle(locale),
                        style: theme.textTheme.titleMedium),
                    Text(coupon.localizedDescription(locale),
                        style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              Chip(label: Text(coupon.percentageLabel())),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(IconlyLight.time_circle,
                  color: expired ? theme.colorScheme.error : theme.colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                expired
                    ? t.t('expired_coupon')
                    : t.t('min_spend').replaceFirst('{min}', coupon.minSpend.toStringAsFixed(0)),
                style: theme.textTheme.bodySmall,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: expired ? null : onApply,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(expired ? t.t('expired_coupon') : t.t('apply')),
              ),
            ],
          )
        ],
      ),
    );
  }
}
