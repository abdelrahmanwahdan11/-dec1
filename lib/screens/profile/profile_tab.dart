import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '../../app.dart';
import '../../controllers/theme_controller.dart';
import '../../localization/app_localizations.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = AppLocalizations.of(context);
    final primaryPresets = ['#23A25D', '#007AFF', '#FF9500', '#9B51E0', '#E63946'];
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(IconlyLight.profile)),
            title: Text(app.authController.displayName),
            subtitle: Text(app.authController.isGuest ? t.t('guest_user') : t.t('member_user')),
          ),
          const Divider(),
          ListTile(
            title: Text(t.t('theme')),
            subtitle: Row(
              children: [
                ChoiceChip(
                  label: const Text('Light'),
                  selected: app.themeController.appThemeMode == AppThemeMode.light,
                  onSelected: (_) => app.themeController.toggleMode(AppThemeMode.light),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text(t.t('system_mode')),
                  selected: app.themeController.appThemeMode == AppThemeMode.system,
                  onSelected: (_) => app.themeController.toggleMode(AppThemeMode.system),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Text(t.t('dark_mode')),
                  selected: app.themeController.appThemeMode == AppThemeMode.dark,
                  onSelected: (_) => app.themeController.toggleMode(AppThemeMode.dark),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(t.t('primary_color')),
            subtitle: Wrap(
              spacing: 8,
              children: primaryPresets
                  .map(
                    (hex) => GestureDetector(
                      onTap: () => app.themeController
                          .updatePrimary(Color(int.parse(hex.replaceFirst('#', '0xff')))),
                      child: CircleAvatar(
                        backgroundColor: Color(int.parse(hex.replaceFirst('#', '0xff'))),
                        radius: 16,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          ListTile(
            title: Text(t.t('language')),
            trailing: DropdownButton<String>(
              value: app.localeController.locale.languageCode,
              onChanged: (v) {
                if (v != null) app.localeController.switchLocale(Locale(v));
              },
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'ar', child: Text('العربية')),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(IconlyLight.chart),
            title: Text(t.t('compare')),
            onTap: () => Navigator.pushNamed(context, '/compare'),
          ),
          ListTile(
            leading: const Icon(IconlyLight.heart),
            title: Text(t.t('favorites')),
            onTap: () => Navigator.pushNamed(context, '/favorites'),
          ),
          ListTile(
            leading: const Icon(IconlyLight.paper),
            title: Text(t.t('orders')),
            onTap: () => Navigator.pushNamed(context, '/orders'),
          ),
          ListTile(
            leading: const Icon(IconlyLight.location),
            title: Text(t.t('stores')),
            onTap: () => Navigator.pushNamed(context, '/stores'),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(t.t('about')),
            onTap: () => Navigator.pushNamed(context, '/about'),
          ),
          ListTile(
            leading: const Icon(IconlyLight.logout),
            title: Text(t.t('logout')),
            onTap: () => app.authController.logout(),
          ),
        ],
      ),
    );
  }
}
