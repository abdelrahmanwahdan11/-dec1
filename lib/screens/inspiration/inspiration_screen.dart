import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';
import '../../data/mock_inspiration.dart';
import '../../localization/app_localizations.dart';
import '../../models/inspiration_article.dart';

class InspirationScreen extends StatelessWidget {
  const InspirationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.t('inspiration'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _hero(context, t),
          const SizedBox(height: 16),
          ...mockInspiration
              .map((article) => _card(context, article, locale, t))
              .toList(),
        ],
      ),
    );
  }

  Widget _hero(BuildContext context, AppLocalizations t) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.t('inspiration_title'), style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(t.t('inspiration_subtitle'), style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          Icon(IconlyBold.info_circle, size: 48, color: Theme.of(context).colorScheme.primary)
              .animate()
              .fadeIn(duration: 300.ms)
              .scale(duration: 300.ms, curve: Curves.easeOutBack),
        ],
      ),
    ).animate().fadeIn(duration: 320.ms);
  }

  Widget _card(BuildContext context, InspirationArticle article, String locale, AppLocalizations t) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _openSheet(context, article, locale, t),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: Image.network(article.heroImage, height: 190, fit: BoxFit.cover)
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .scale(begin: const Offset(0.98, 0.98), duration: 300.ms),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.14),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(article.tag, style: Theme.of(context).textTheme.labelMedium),
                      ),
                      const Spacer(),
                      Icon(IconlyLight.arrow_right, color: Theme.of(context).colorScheme.primary),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(article.localizedTitle(locale), style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(article.localizedSummary(locale)),
                ],
              ),
            )
          ],
        ),
      ),
    ).animate().slideX(begin: -0.04, duration: 260.ms).fadeIn(duration: 260.ms);
  }

  void _openSheet(BuildContext context, InspirationArticle article, String locale, AppLocalizations t) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.95,
          builder: (context, controller) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(article.localizedTitle(locale), style: Theme.of(context).textTheme.titleMedium),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(IconlyLight.paper),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: controller,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(article.heroImage, height: 180, fit: BoxFit.cover)
                                .animate()
                                .fadeIn(duration: 240.ms),
                          ),
                          const SizedBox(height: 12),
                          Text(article.localizedBody(locale), style: Theme.of(context).textTheme.bodyLarge),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(IconlyLight.heart, color: Theme.of(context).colorScheme.primary),
                              const SizedBox(width: 6),
                              Text(t.t('save_idea')), 
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
