import 'package:flutter/material.dart';
import '../../localization/app_localizations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final features = [
      t.t('about_feature_theme'),
      t.t('about_feature_compare'),
      t.t('about_feature_checkout'),
      t.t('about_feature_localization'),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(t.t('about'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.t('app_name'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(t.t('about_description')),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Chip(label: Text(t.t('version_1'))),
                      const SizedBox(width: 8),
                      Chip(label: Text(t.t('built_with_flutter'))),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(t.t('about_highlights'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...features.map(
            (f) => ListTile(
              leading: const Icon(Icons.eco_outlined),
              title: Text(f),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.t('contact'), style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(t.t('contact_email')),
                  const SizedBox(height: 4),
                  Text(t.t('contact_message')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
