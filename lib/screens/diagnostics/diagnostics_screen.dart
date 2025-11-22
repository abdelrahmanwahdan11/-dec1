import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';
import '../../app.dart';
import '../../localization/app_localizations.dart';
import '../../models/plant_symptom.dart';

class DiagnosticsScreen extends StatelessWidget {
  const DiagnosticsScreen({super.key});

  Color _severityColor(BuildContext context, SymptomSeverity severity) {
    switch (severity) {
      case SymptomSeverity.low:
        return Colors.green;
      case SymptomSeverity.medium:
        return Colors.orange;
      case SymptomSeverity.high:
        return Colors.red;
    }
  }

  String _severityLabel(AppLocalizations t, SymptomSeverity severity) {
    switch (severity) {
      case SymptomSeverity.low:
        return t.t('severity_low');
      case SymptomSeverity.medium:
        return t.t('severity_medium');
      case SymptomSeverity.high:
        return t.t('severity_high');
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.t('diagnostics')),
        actions: [
          IconButton(
            icon: const Icon(IconlyLight.refresh),
            onPressed: () => app.diagnosticsController.setFilter(null),
          )
              .animate()
              .scale(delay: 100.ms, duration: 300.ms)
              .fadeIn(delay: 100.ms),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.12),
                  Theme.of(context).colorScheme.primary.withOpacity(0.04),
                ]),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.t('diagnostics_headline'),
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 6),
                        Text(t.t('diagnostics_subtitle')),
                        const SizedBox(height: 12),
                        AnimatedBuilder(
                          animation: app.diagnosticsController,
                          builder: (context, _) {
                            return Wrap(
                              spacing: 8,
                              children: [
                                _filterChip(context, t.t('severity_all'), null, app),
                                _filterChip(
                                    context, t.t('severity_low'), SymptomSeverity.low, app),
                                _filterChip(context, t.t('severity_medium'), SymptomSeverity.medium, app),
                                _filterChip(context, t.t('severity_high'), SymptomSeverity.high, app),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(IconlyBold.shield_done,
                          color: Theme.of(context).colorScheme.primary, size: 56)
                      .animate()
                      .scale(duration: 400.ms)
                      .shake(delay: 300.ms, amount: 4, hz: 3),
                ],
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: app.diagnosticsController.symptoms,
              builder: (context, symptoms, _) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: symptoms.length,
                  itemBuilder: (context, index) {
                    final symptom = symptoms[index];
                    final color = _severityColor(context, symptom.severity);
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Icon(IconlyLight.activity, color: color),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(symptom.localizedTitle(locale),
                                          style: Theme.of(context).textTheme.titleMedium),
                                      Text(_severityLabel(t, symptom.severity),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(color: color)),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    symptom.resolved
                                        ? IconlyBold.shield_done
                                        : IconlyLight.tick_square,
                                    color: color,
                                  ),
                                  onPressed: () => app.diagnosticsController.toggleResolved(symptom.id),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(symptom.localizedDescription(locale)),
                            const SizedBox(height: 12),
                            ...symptom.localizedSteps(locale).map((step) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(IconlyLight.time_circle,
                                              size: 16,
                                              color: Theme.of(context).colorScheme.primary)
                                          .animate()
                                          .scale(duration: 300.ms, delay: (index * 50).ms),
                                      const SizedBox(width: 8),
                                      Expanded(child: Text(step)),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 260.ms, delay: (index * 70).ms)
                        .slideY(begin: 0.05);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(BuildContext context, String label, SymptomSeverity? severity, AppScope app) {
    final isSelected = app.diagnosticsController.currentFilter == severity;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => app.diagnosticsController.setFilter(severity),
    );
  }
}
