import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../app.dart';
import '../../data/mock_challenges.dart';
import '../../localization/app_localizations.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppScope.of(context).challengesController.load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scope = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.t('challenges')),
        actions: [
          TextButton(
            onPressed: () {
              for (final challenge in mockChallenges) {
                scope.challengesController.reset(challenge.id);
              }
            },
            child: Text(l10n.t('reset_all')),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: scope.challengesController.state,
        builder: (context, state, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                ),
                child: Row(
                  children: [
                    Icon(Icons.flag_rounded,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.t('challenge_headline'),
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 4),
                          Text(
                            l10n.t('challenge_subtitle'),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Theme.of(context).hintColor),
                          ),
                        ],
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: Text(l10n.t('get_started')),
                    )
                  ],
                ),
              ).animate().fadeIn(duration: 320.ms).slideY(begin: .2, end: 0),
              const SizedBox(height: 12),
              ...mockChallenges.mapIndexed((index, challenge) {
                final isComplete = state.isComplete(challenge.id, challenge.target);
                final progress = state.progressFor(challenge.id, challenge.target);
                final isRtl = l10n.locale.languageCode == 'ar';
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.12),
                            child: Icon(
                              isComplete
                                  ? Icons.check_circle
                                  : Icons.bolt_rounded,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isRtl ? challenge.titleAr : challenge.titleEn,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  isRtl
                                      ? challenge.descriptionAr
                                      : challenge.descriptionEn,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Theme.of(context).hintColor),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer
                                  .withOpacity(0.6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '+${challenge.rewardPoints} ${l10n.t('pts')}',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor:
                            Theme.of(context).colorScheme.surfaceVariant,
                      ).animate().slideX(begin: -.2, end: 0).fadeIn(),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            l10n
                                .t('challenge_progress')
                                .replaceAll('{current}',
                                    '${state.progress[challenge.id] ?? 0}')
                                .replaceAll('{target}', '${challenge.target}'),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          if (!isComplete)
                            TextButton.icon(
                              onPressed: () => scope.challengesController
                                  .increment(challenge.id, challenge.target),
                              icon: const Icon(Icons.check),
                              label: Text(l10n.t('mark_step')),
                            ),
                          if (isComplete)
                            Chip(
                              label: Text(l10n.completed),
                              avatar: const Icon(Icons.auto_awesome, size: 18),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.12),
                            ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () =>
                                scope.challengesController.reset(challenge.id),
                            icon: const Icon(Icons.refresh_rounded),
                          )
                        ],
                      )
                    ],
                  ),
                ).animate(delay: (index * 80).ms).fadeIn(duration: 320.ms).slideY(begin: .1);
              }),
            ],
          );
        },
      ),
    );
  }
}

extension _Indexed<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int, E) toElement) sync* {
    var i = 0;
    for (final element in this) {
      yield toElement(i, element);
      i++;
    }
  }
}
