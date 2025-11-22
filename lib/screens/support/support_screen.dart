import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';
import '../../localization/app_localizations.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final faqs = [
      {'q': t.t('faq_shipping'), 'a': t.t('faq_shipping_answer')},
      {'q': t.t('faq_care'), 'a': t.t('faq_care_answer')},
      {'q': t.t('faq_returns'), 'a': t.t('faq_returns_answer')},
    ];
    final guidedCards = [
      {'icon': IconlyBold.shield_done, 'title': t.t('support_delivery'), 'subtitle': t.t('support_delivery_desc')},
      {'icon': IconlyBold.heart, 'title': t.t('support_care'), 'subtitle': t.t('support_care_desc')},
      {'icon': IconlyBold.wallet, 'title': t.t('support_payments'), 'subtitle': t.t('support_payments_desc')},
    ];

    return Scaffold(
      appBar: AppBar(title: Text(t.t('support'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SupportHero(t: t),
          const SizedBox(height: 12),
          Text(t.t('support_cards'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...guidedCards.asMap().entries.map(
            (entry) => _GuidedCard(
              iconData: entry.value['icon'] as IconData,
              title: entry.value['title'] as String,
              subtitle: entry.value['subtitle'] as String,
              delayMs: entry.key * 80,
            ),
          ),
          const SizedBox(height: 16),
          Text(t.t('faqs'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...faqs.asMap().entries.map(
            (entry) => _FaqTile(
              question: entry.value['q']!,
              answer: entry.value['a']!,
              delayMs: entry.key * 60,
            ),
          ),
          const SizedBox(height: 16),
          Text(t.t('contact_support'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _SupportAction(
                icon: IconlyBold.message,
                label: t.t('chat_now'),
                onTap: () => _showSnack(context, t),
              ),
              _SupportAction(
                icon: IconlyBold.message,
                label: t.t('support_email'),
                onTap: () => _showSnack(context, t),
              ),
              _SupportAction(
                icon: IconlyBold.call,
                label: t.t('support_call'),
                onTap: () => _showSnack(context, t),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(t.t('support_notes'), style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  void _showSnack(BuildContext context, AppLocalizations t) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t.t('support_success'))),
    );
  }
}

class _SupportHero extends StatelessWidget {
  final AppLocalizations t;
  const _SupportHero({required this.t});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.t('support_header'), style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(t.t('help_center_subtitle')),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?auto=format&fit=crop&w=320&q=80',
              width: 96,
              height: 96,
              fit: BoxFit.cover,
            ),
          ).animate().fadeIn(duration: 420.ms).scale(begin: 0.9, end: 1.0),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.08, end: 0);
  }
}

class _GuidedCard extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String subtitle;
  final int delayMs;

  const _GuidedCard({
    required this.iconData,
    required this.title,
    required this.subtitle,
    required this.delayMs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const Icon(IconlyLight.arrow_right_2),
        ],
      ),
    ).animate(delay: delayMs.ms).fadeIn(duration: 320.ms).slideX(begin: 0.1, end: 0);
  }
}

class _FaqTile extends StatefulWidget {
  final String question;
  final String answer;
  final int delayMs;

  const _FaqTile({
    required this.question,
    required this.answer,
    required this.delayMs,
  });

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        shape: const Border(),
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        leading: Icon(expanded ? IconlyBold.minus : IconlyBold.plus, color: Theme.of(context).colorScheme.primary),
        title: Text(widget.question),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Text(widget.answer),
          ),
        ],
        onExpansionChanged: (v) => setState(() => expanded = v),
      ),
    ).animate(delay: widget.delayMs.ms).fadeIn(duration: 260.ms).slideY(begin: 0.08, end: 0);
  }
}

class _SupportAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SupportAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
