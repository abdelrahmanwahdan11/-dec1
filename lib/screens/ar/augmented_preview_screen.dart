import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../app.dart';
import '../../data/mock_ar_scenes.dart';
import '../../localization/app_localizations.dart';

class AugmentedPreviewScreen extends StatelessWidget {
  const AugmentedPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.t('ar_preview')),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => showModalBottomSheet(
              context: context,
              showDragHandle: true,
              builder: (_) => _ArHowItWorks(t: t),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: app.arController.scene,
              builder: (context, scene, _) => ValueListenableBuilder<double>(
                valueListenable: app.arController.scale,
                builder: (context, scale, __) {
                  return Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      image: DecorationImage(
                        image: NetworkImage(scene.imageUrl),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.12),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ValueListenableBuilder<bool>(
                            valueListenable: app.arController.showGrid,
                            builder: (context, grid, __) => AnimatedOpacity(
                              duration: 300.ms,
                              opacity: grid ? 0.4 : 0,
                              child: CustomPaint(
                                painter: _GridPainter(color: Colors.white54),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: ValueListenableBuilder<bool>(
                            valueListenable: app.arController.showShadow,
                            builder: (context, shadow, __) => FractionallySizedBox(
                              widthFactor: 0.4 * scale,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  boxShadow: shadow
                                      ? [
                                          BoxShadow(
                                            blurRadius: 28,
                                            spreadRadius: 6,
                                            color: Colors.black.withOpacity(0.18),
                                            offset: const Offset(0, 18),
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Hero(
                                  tag: 'ar_${scene.id}',
                                  child: Image.network(
                                    'https://images.unsplash.com/photo-1524592094714-0f0654e20314?auto=format&fit=crop&w=800&q=80',
                                    fit: BoxFit.contain,
                                  )
                                      .animate(onPlay: (c) => c.repeat())
                                      .shimmer(duration: 2.seconds, color: Colors.white24)
                                      .then()
                                      .shake(hz: 1, amount: 4, curve: Curves.easeInOut),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.35),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  locale.languageCode == 'ar' ? scene.titleAr : scene.titleEn,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(color: Colors.white),
                                ),
                                Text(
                                  locale.languageCode == 'ar'
                                      ? scene.descriptionAr
                                      : scene.descriptionEn,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.white70),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(duration: 280.ms).slideY(begin: 0.1),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .scale(begin: const Offset(0.98, 0.98), duration: 300.ms)
                      .fadeIn(duration: 320.ms);
                },
              ),
            ),
            const SizedBox(height: 16),
            _Controls(app: app, t: t),
            const SizedBox(height: 16),
            _SceneSelector(app: app, t: t),
          ],
        ),
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({required this.app, required this.t});

  final AppScope app;
  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.t('ar_scale'), style: Theme.of(context).textTheme.titleMedium),
                  ValueListenableBuilder<double>(
                    valueListenable: app.arController.scale,
                    builder: (context, value, _) => Slider(
                      value: value,
                      min: 0.6,
                      max: 1.6,
                      onChanged: (v) => app.arController.updateScale(v),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: app.arController.showShadow,
                  builder: (context, value, _) => Row(
                    children: [
                      Switch(
                        value: value,
                        onChanged: (v) => app.arController.toggleShadow(v),
                      ),
                      Text(t.t('ar_shadow')),
                    ],
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: app.arController.showGrid,
                  builder: (context, value, _) => Row(
                    children: [
                      Switch(
                        value: value,
                        onChanged: (v) => app.arController.toggleGrid(v),
                      ),
                      Text(t.t('ar_grid')),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
          ),
          child: Row(
            children: [
              const Icon(Icons.auto_fix_high_outlined),
              const SizedBox(width: 10),
              Expanded(child: Text(t.t('ar_tip'))),
              TextButton(
                onPressed: () => ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(t.t('ar_mock')))),
                child: Text(t.t('preview')),
              ).animate().scale(delay: 150.ms, begin: const Offset(0.95, 0.95)),
            ],
          ),
        ).animate().slide(begin: const Offset(0, 0.1)).fadeIn(duration: 260.ms),
      ],
    );
  }
}

class _SceneSelector extends StatelessWidget {
  const _SceneSelector({required this.app, required this.t});

  final AppScope app;
  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.t('ar_spaces'), style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: mockArScenes.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = mockArScenes[index];
              return ValueListenableBuilder(
                valueListenable: app.arController.scene,
                builder: (context, current, _) => GestureDetector(
                  onTap: () => app.arController.selectScene(item),
                  child: AnimatedContainer(
                    duration: 200.ms,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: current.id == item.id
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                      image: DecorationImage(
                        image: NetworkImage(item.imageUrl),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.15),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            locale.languageCode == 'ar' ? item.titleAr : item.titleEn,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            locale.languageCode == 'ar'
                                ? item.descriptionAr
                                : item.descriptionEn,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate()
                      .scale(begin: const Offset(0.97, 0.97))
                      .fadeIn(duration: 200.ms)
                      .slideX(begin: -0.05 * index),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ArHowItWorks extends StatelessWidget {
  const _ArHowItWorks({required this.t});

  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.t('ar_how'), style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          ...[t.t('ar_step_one'), t.t('ar_step_two'), t.t('ar_step_three')]
              .map((step) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(child: Text(step)),
                      ],
                    ).animate().slideX(begin: -0.05).fadeIn(),
                  )),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
