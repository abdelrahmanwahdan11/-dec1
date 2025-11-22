import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';
import '../../app.dart';
import '../../data/mock_gift_options.dart';
import '../../localization/app_localizations.dart';
import '../../models/gift_option.dart';
import '../../widgets/primary_button.dart';

class GiftingScreen extends StatefulWidget {
  const GiftingScreen({super.key});

  @override
  State<GiftingScreen> createState() => _GiftingScreenState();
}

class _GiftingScreenState extends State<GiftingScreen> {
  late TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.t('gifting_center')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _hero(t, context),
            const SizedBox(height: 16),
            Text(t.t('wrap_style'), style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ValueListenableBuilder<String>(
              valueListenable: app.giftController.selectedWrap,
              builder: (context, selected, _) {
                return Wrap(
                  spacing: 10,
                  children: ['#23A25D', '#E1E8F0', '#C08A3E', '#FF9500', '#9B51E0']
                      .map(
                        (hex) => GestureDetector(
                          onTap: () => app.giftController.chooseWrap(hex),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selected == hex
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundColor: Color(int.parse(hex.replaceFirst('#', '0xff'))),
                              radius: 20,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(t.t('gift_message'), style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ValueListenableBuilder<String>(
              valueListenable: app.giftController.message,
              builder: (context, message, _) {
                if (_messageController.text != message) {
                  _messageController.text = message;
                  _messageController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _messageController.text.length));
                }
                return TextField(
                  controller: _messageController,
                  maxLines: 3,
                  onChanged: (value) => app.giftController.updateMessage(value),
                  decoration: InputDecoration(
                    hintText: t.t('gift_message_hint'),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 300.ms)
                    .slideX(begin: 0.03);
              },
            ),
            const SizedBox(height: 16),
            Text(t.t('gift_recommendations'),
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ValueListenableBuilder<List<GiftOption>>(
              valueListenable: app.giftController.options,
              builder: (context, options, _) {
                return Column(
                  children: options
                      .map((option) => _giftCard(context, option, locale, app))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _giftCard(BuildContext context, GiftOption option, Locale locale, AppScope app) {
    final t = AppLocalizations.of(context);
    final plant = app.catalogController.findById(option.plantId);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(option.imageUrl, width: 96, height: 96, fit: BoxFit.cover),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(option.localizedTitle(locale.languageCode),
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(option.localizedDescription(locale.languageCode)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(IconlyLight.ticket, size: 16, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 6),
                          Text(t.t('wrap_label').replaceFirst('{color}', option.wrapHex)),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(IconlyBold.heart, color: Theme.of(context).colorScheme.primary)
                    .animate()
                    .scale(duration: 400.ms, delay: 200.ms)
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text('${option.price.toStringAsFixed(2)} USD',
                    style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                PrimaryButton(
                  label: t.t('add_gift'),
                  onPressed: plant == null
                      ? null
                      : () {
                          app.cartController.addToCart(plant);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(t.t('gift_added'))),
                          );
                        },
                ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 260.ms)
        .slideY(begin: 0.04);
  }

  Widget _hero(AppLocalizations t, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(colors: [
          Theme.of(context).colorScheme.primary.withOpacity(0.12),
          Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        ]),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.t('gifting_hero_title'), style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 6),
                Text(t.t('gifting_hero_body')),
                const SizedBox(height: 12),
                PrimaryButton(
                  label: t.t('gift_cta'),
                  onPressed: () => Navigator.pushNamed(context, '/coupons'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              mockGiftOptions.first.imageUrl,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            )
                .animate()
                .scale(duration: 380.ms)
                .shimmer(duration: 1200.ms,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 240.ms)
        .slideX(begin: 0.04);
  }
}
