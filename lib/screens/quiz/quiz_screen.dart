import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../app.dart';
import '../../localization/app_localizations.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.92);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppScope.of(context).quizController.load();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scope = AppScope.of(context);
    final questions = scope.quizController.questions;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.t('quizzes_title')),
        actions: [
          TextButton(
            onPressed: () => scope.quizController.reset(),
            child: Text(l10n.t('restart_quiz')),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: scope.quizController.state,
        builder: (context, state, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.t('quiz_headline'),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.t('quiz_subtitle'),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Theme.of(context).hintColor),
                          ),
                        ],
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Column(
                          children: [
                            Text('${state.answers.length}/${questions.length}',
                                style: Theme.of(context).textTheme.titleMedium),
                            Text(l10n.t('progress_label'),
                                style: Theme.of(context).textTheme.labelMedium),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: .2, end: 0),
              if (state.completed)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _buildScoreCard(context, l10n, questions.length, state.score),
                ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: questions.length,
                  onPageChanged: (index) => scope.quizController.setCurrentIndex(index),
                  itemBuilder: (context, index) {
                    final question = questions[index];
                    final selected = state.answers[question.id];
                    final isRtl = l10n.locale.languageCode == 'ar';
                    final questionText =
                        isRtl ? question.questionAr : question.questionEn;
                    return AnimatedSwitcher(
                      duration: 300.ms,
                      child: Container(
                        key: ValueKey(question.id + (selected?.toString() ?? '')),
                        margin: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 8,
                              children: [
                                Chip(
                                  label: Text(l10n
                                      .t('question_label')
                                      .replaceAll('{index}', '${index + 1}')),
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.08),
                                ),
                                Chip(
                                  label: Text(l10n.t('quiz_chip')),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.surfaceVariant,
                                ),
                              ],
                            ).animate().fadeIn(duration: 250.ms).scale(begin: const Offset(.95, .95)),
                            const SizedBox(height: 8),
                            Text(
                              questionText,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ).animate().slideY(begin: .2, end: 0).fadeIn(duration: 300.ms),
                            const SizedBox(height: 12),
                            ...List.generate(question.options.length, (optIndex) {
                              final option = question.options[optIndex];
                              final optionText =
                                  isRtl ? option.textAr : option.textEn;
                              final bool isCorrect = optIndex == question.correctIndex;
                              final bool isSelected = selected == optIndex;
                              Color borderColor = Colors.transparent;
                              Color fillColor = Theme.of(context).colorScheme.surface;
                              if (selected != null) {
                                if (isCorrect) {
                                  borderColor = Theme.of(context).colorScheme.primary;
                                  fillColor = Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.12);
                                } else if (isSelected) {
                                  borderColor = Theme.of(context).colorScheme.error;
                                  fillColor = Theme.of(context)
                                      .colorScheme
                                      .error
                                      .withOpacity(0.08);
                                }
                              }
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () => scope.quizController
                                      .selectAnswer(question.id, optIndex),
                                  child: AnimatedContainer(
                                    duration: 220.ms,
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: fillColor,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: borderColor,
                                        width: 1.4,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          isCorrect
                                              ? Icons.eco_rounded
                                              : Icons.radio_button_unchecked,
                                          color: isCorrect
                                              ? Theme.of(context).colorScheme.primary
                                              : Theme.of(context).hintColor,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            optionText,
                                            style: Theme.of(context).textTheme.bodyLarge,
                                          ),
                                        ),
                                        if (isSelected)
                                          Icon(
                                            isCorrect ? Icons.check_circle : Icons.close,
                                            color: isCorrect
                                                ? Theme.of(context).colorScheme.primary
                                                : Theme.of(context).colorScheme.error,
                                          ).animate().scale(begin: const Offset(.8, .8)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                            if (selected != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Text(
                                      isRtl
                                          ? question.explanationAr
                                          : question.explanationEn,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                    ),
                                  ),
                                ).animate().fadeIn(duration: 300.ms).slideY(begin: .1, end: 0),
                              ),
                          ],
                        ),
                      ).animate(delay: (index * 80).ms).fadeIn(duration: 320.ms).slideX(begin: .08),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildScoreCard(
    BuildContext context,
    AppLocalizations l10n,
    int total,
    int score,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.celebration, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.t('quiz_complete_title'),
                    style: Theme.of(context).textTheme.titleMedium),
                Text(
                    l10n
                        .t('quiz_complete_subtitle')
                        .replaceAll('{score}', '$score')
                        .replaceAll('{total}', '$total'),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Theme.of(context).hintColor)),
              ],
            ),
          ),
          FilledButton(
            onPressed: () {
              _pageController.animateToPage(
                0,
                duration: 350.ms,
                curve: Curves.easeInOut,
              );
              AppScope.of(context).quizController.reset();
            },
            child: Text(l10n.t('restart_quiz')),
          ),
        ],
      ),
    );
  }
}
