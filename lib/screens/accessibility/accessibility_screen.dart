import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../app.dart';
import '../../controllers/accessibility_controller.dart';
import '../../localization/app_localizations.dart';

class AccessibilityScreen extends StatelessWidget {
  const AccessibilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final controller = AppScope.of(context).accessibilityController;
    return Scaffold(
      appBar: AppBar(title: Text(t.t('accessibility'))),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _headerCard(context, t),
              const SizedBox(height: 12),
              _textScaleSlider(context, t, controller),
              const SizedBox(height: 12),
              _toggleTiles(context, t, controller),
              const SizedBox(height: 12),
              _previewCard(context, t, controller),
            ],
          );
        },
      ),
    );
  }

  Widget _headerCard(BuildContext context, AppLocalizations t) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(colors: [
          Theme.of(context).colorScheme.primary.withOpacity(0.18),
          Theme.of(context).colorScheme.primary.withOpacity(0.08),
        ]),
      ),
      child: Row(
        children: [
          const Icon(Icons.accessibility_new_rounded, size: 38),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.t('accessibility_hint'), style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(t.t('motion_disabled'), style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          )
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.06);
  }

  Widget _textScaleSlider(
      BuildContext context, AppLocalizations t, AccessibilityController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.t('text_size'), style: Theme.of(context).textTheme.titleMedium),
          Slider(
            value: controller.textScale,
            min: 0.9,
            max: 1.3,
            onChanged: (v) => controller.updateTextScale(v),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0.9x'),
              Text('${controller.textScale.toStringAsFixed(2)}x'),
              Text('1.3x'),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: -0.05);
  }

  Widget _toggleTiles(
      BuildContext context, AppLocalizations t, AccessibilityController controller) {
    return Column(
      children: [
        SwitchListTile(
          title: Text(t.t('reduce_motion')),
          subtitle: Text(t.t('reduce_motion_hint')),
          value: controller.reduceMotion,
          onChanged: controller.toggleReduceMotion,
        ).animate().fadeIn().slideX(begin: 0.05),
        SwitchListTile(
          title: Text(t.t('high_contrast')),
          subtitle: Text(t.t('high_contrast_hint')),
          value: controller.highContrast,
          onChanged: controller.toggleHighContrast,
        ).animate().fadeIn().slideX(begin: 0.05, end: 0),
      ],
    );
  }

  Widget _previewCard(
      BuildContext context, AppLocalizations t, AccessibilityController controller) {
    final baseTheme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: controller.highContrast
            ? baseTheme.colorScheme.primary.withOpacity(0.2)
            : baseTheme.cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.t('preview'), style: baseTheme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            t.t('preview_body'),
            style: baseTheme.textTheme.bodyMedium,
            textScaleFactor: controller.textScale,
          ),
          const SizedBox(height: 12),
          AnimatedOpacity(
            opacity: controller.reduceMotion ? 0.7 : 1,
            duration: const Duration(milliseconds: 300),
            child: ElevatedButton(
              onPressed: () {},
              child: Text(t.t('save_entry')),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.97, 0.97));
  }
}
