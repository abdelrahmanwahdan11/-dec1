import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../controllers/onboarding_controller.dart';
import '../../localization/app_localizations.dart';
import '../../widgets/primary_button.dart';

class OnboardingScreen extends StatefulWidget {
  final OnboardingController onboardingController;
  final VoidCallback onFinish;
  const OnboardingScreen({super.key, required this.onboardingController, required this.onFinish});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _images = const [
    'https://images.unsplash.com/photo-1470246973918-29a93221c455?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1483794344563-d27a8d18014e?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=1200&q=80',
  ];

  @override
  void initState() {
    super.initState();
    widget.onboardingController.startAutoSlide(_images.length);
  }

  @override
  void dispose() {
    widget.onboardingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final pages = [
      (t.t('onboard_title_1'), t.t('onboard_desc_1')),
      (t.t('onboard_title_2'), t.t('onboard_desc_2')),
      (t.t('onboard_title_3'), t.t('onboard_desc_3')),
    ];
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(onPressed: _finish, child: Text(t.t('skip'))),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: widget.onboardingController.pageController,
              onPageChanged: widget.onboardingController.onPageChanged,
              itemCount: pages.length,
              itemBuilder: (context, index) {
                final page = pages[index];
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: Image.network(_images[index], fit: BoxFit.cover)
                              .animate()
                              .fadeIn(duration: 400.ms)
                              .slide(begin: const Offset(0, 0.04)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(page.$1, style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 12),
                      Text(page.$2, textAlign: TextAlign.center),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
          ValueListenableBuilder<int>(
            valueListenable: widget.onboardingController.index,
            builder: (context, value, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 8,
                    width: value == i ? 22 : 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 18),
                    decoration: BoxDecoration(
                      color: value == i
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: PrimaryButton(label: t.t('get_started'), onPressed: _finish),
          ),
        ],
      ),
    );
  }

  Future<void> _finish() async {
    await widget.onboardingController.markSeen();
    widget.onFinish();
  }
}
