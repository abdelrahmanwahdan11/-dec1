import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../app.dart';
import '../../localization/app_localizations.dart';

class PrivacyCenterScreen extends StatelessWidget {
  const PrivacyCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = AppLocalizations.of(context)!;
    return AnimatedBuilder(
      animation: app.accessibilityController,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: Text(t.t('privacy_center'))),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(t.t('privacy_overview'), style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 12),
              _card(
                context,
                title: t.t('privacy_controls'),
                subtitle: t.t('privacy_controls_hint'),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: app.accessibilityController.allowAnalytics,
                      onChanged: app.accessibilityController.toggleAnalytics,
                      title: Text(t.t('analytics_opt_in')),
                      subtitle: Text(t.t('analytics_opt_in_hint')),
                    ),
                    SwitchListTile(
                      value: app.accessibilityController.allowPersonalization,
                      onChanged: app.accessibilityController.togglePersonalization,
                      title: Text(t.t('personalized_tips')),
                      subtitle: Text(t.t('personalized_tips_hint')),
                    ),
                    SwitchListTile(
                      value: app.accessibilityController.allowEmailTips,
                      onChanged: app.accessibilityController.toggleEmailTips,
                      title: Text(t.t('email_tips')),
                      subtitle: Text(t.t('email_tips_hint')),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _card(
                context,
                title: t.t('data_actions'),
                subtitle: t.t('data_actions_hint'),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.file_download_outlined),
                      title: Text(t.t('export_data')),
                      subtitle: Text(t.t('export_data_hint')),
                      trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(t.t('export_ready'))),
                          );
                        },
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.cleaning_services_outlined),
                      title: Text(t.t('clear_recommendations')),
                      subtitle: Text(t.t('clear_recommendations_hint')),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(t.t('recommendations_cleared'))),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.verified_user_outlined),
                      title: Text(t.t('security_note')),
                      subtitle: Text(t.t('security_note_hint')),
                    ),
                  ],
                ),
              ),
            ],
          ).animate().fadeIn(duration: 350.ms).slide(begin: const Offset(0, 0.02)),
        );
      },
    );
  }

  Widget _card(BuildContext context,
      {required String title, required String subtitle, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: kElevationToShadow[2],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          child,
        ],
      ),
    ).animate().shimmer(duration: 800.ms, color: Theme.of(context).primaryColor.withOpacity(0.05));
  }
}
