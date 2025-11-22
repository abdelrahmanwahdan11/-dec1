import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';
import '../../app.dart';
import '../../localization/app_localizations.dart';

class ReferralsScreen extends StatelessWidget {
  const ReferralsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.t('referrals'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.9),
                  Theme.of(context).colorScheme.primary.withOpacity(0.6),
                ]),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.t('invite_title'),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(t.t('invite_body'),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white70)),
                  const SizedBox(height: 16),
                  _CodeTile(code: app.referralController.code),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            app.referralController.incrementSent();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(t.t('share_hint'))));
                          },
                          icon: const Icon(IconlyLight.send),
                          label: Text(t.t('share_now')),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          app.referralController.markJoined();
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(t.t('joined_mock'))));
                        },
                        icon: const Icon(Icons.add_task, color: Colors.white),
                      )
                    ],
                  )
                ],
              ),
            ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.04),
            const SizedBox(height: 16),
            _StatsGrid(app: app, t: t),
            const SizedBox(height: 16),
            _HowItWorks(t: t),
          ],
        ),
      ),
    );
  }
}

class _CodeTile extends StatelessWidget {
  final String code;
  const _CodeTile({required this.code});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
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
              Text(t.t('share_code')),
              Text(code, style: Theme.of(context).textTheme.titleMedium),
            ],
          )),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(t.t('copied'))));
            },
            icon: const Icon(Icons.copy),
          )
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final AppScope app;
  final AppLocalizations t;
  const _StatsGrid({required this.app, required this.t});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _statCard(
          context,
          icon: IconlyBold.send,
          title: t.t('invites_sent'),
          listenable: app.referralController.invitesSent,
        ),
        const SizedBox(width: 10),
        _statCard(
          context,
          icon: IconlyBold.user_2,
          title: t.t('friends_joined'),
          listenable: app.referralController.friendsJoined,
        ),
        const SizedBox(width: 10),
        _statCard(
          context,
          icon: IconlyBold.star,
          title: t.t('reward_points'),
          listenable: app.referralController.rewards,
        ),
      ],
    );
  }

  Widget _statCard(BuildContext context,
      {required IconData icon,
      required String title,
      required ValueListenable<int> listenable}) {
    return Expanded(
      child: ValueListenableBuilder<int>(
        valueListenable: listenable,
        builder: (context, value, _) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 6),
                Text(title, textAlign: TextAlign.center),
                Text('$value', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ).animate().fadeIn().scale(delay: 80.ms);
        },
      ),
    );
  }
}

class _HowItWorks extends StatelessWidget {
  final AppLocalizations t;
  const _HowItWorks({required this.t});

  @override
  Widget build(BuildContext context) {
    final steps = [
      t.t('refer_step1'),
      t.t('refer_step2'),
      t.t('refer_step3'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.t('how_it_works'), style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...steps.asMap().entries.map((entry) {
          final idx = entry.key + 1;
          final text = entry.value;
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
              child: Text('$idx'),
            ),
            title: Text(text),
          ).animate().slideX(begin: -0.05).fadeIn(delay: (idx * 60).ms);
        })
      ],
    );
  }
}
