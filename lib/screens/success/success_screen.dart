import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../localization/app_localizations.dart';
import '../main/main_shell_screen.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 120, color: Colors.green)
                .animate()
                .scale(duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(height: 12),
            Text(t.t('success_title'), style: Theme.of(context).textTheme.headlineSmall)
                .animate()
                .fadeIn(duration: 400.ms),
            const SizedBox(height: 8),
            Text(t.t('success_subtitle')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (_) => const MainShellScreen()), (route) => false),
              child: Text(t.t('back_home')),
            ),
          ],
        ),
      ),
    );
  }
}
