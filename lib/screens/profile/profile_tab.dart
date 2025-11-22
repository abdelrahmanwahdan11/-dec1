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
            title: Text(t.t('guides')),
            onTap: () => Navigator.pushNamed(context, '/guides'),
          ),
          ListTile(
            leading: const Icon(IconlyLight.star),
            title: Text(t.t('rewards')),
            onTap: () => Navigator.pushNamed(context, '/rewards'),
          ),
          ListTile(
            leading: const Icon(IconlyLight.ticket),
            title: Text(t.t('coupons')),
            subtitle: Text(t.t('coupon_center')),
            onTap: () => Navigator.pushNamed(context, '/coupons'),
          ),
          ListTile(
            leading: const Icon(IconlyLight.send),
            title: Text(t.t('referrals')),
            subtitle: Text(t.t('invite_hint')),
            onTap: () => Navigator.pushNamed(context, '/referrals'),
          ),
          ListTile(
            leading: const Icon(IconlyLight.calendar),
            title: Text(t.t('care_schedule')),
            onTap: () => Navigator.pushNamed(context, '/care'),
          ),
          ListTile(
            leading: const Icon(IconlyLight.calendar),
            title: Text(t.t('care_calendar')),
            onTap: () => Navigator.pushNamed(context, '/care/calendar'),
          ),
          ListTile(
            leading: const Icon(IconlyLight.shield_done),
            title: Text(t.t('diagnostics')),
            subtitle: Text(t.t('diagnostics_hint')),
            onTap: () => Navigator.pushNamed(context, '/diagnostics'),
          ),
          ListTile(
            leading: const Icon(Icons.card_giftcard_outlined),
            title: Text(t.t('gifting_center')),
            subtitle: Text(t.t('gifting_hint')),
            onTap: () => Navigator.pushNamed(context, '/gifting'),
          ),
          ListTile(
            leading: const Icon(IconlyLight.notification),
            title: Text(t.t('notifications')),
            onTap: () => Navigator.pushNamed(context, '/notifications'),
          ),
          ListTile(
            leading: const Icon(IconlyLight.paper),
            title: Text(t.t('orders')),
            onTap: () => Navigator.pushNamed(context, '/orders'),
          ),
          ListTile(
            leading: const Icon(IconlyLight.location),
            title: Text(t.t('addresses')),
            subtitle: Text(t.t('shipping_address')),
            onTap: () => Navigator.pushNamed(context, '/addresses'),
          ),
          ListTile(
            leading: const Icon(IconlyLight.time_circle),
            title: Text(t.t('recently_viewed')),
            onTap: () => Navigator.pushNamed(context, '/recent'),
          ),
          ListTile(
            leading: const Icon(Icons.menu_book_outlined),
            title: Text(t.t('journal')),
            subtitle: Text(t.t('journal_hint')),
            onTap: () => Navigator.pushNamed(context, '/journal'),
          ),
          ListTile(
            leading: const Icon(Icons.upgrade_outlined),
            title: Text(t.t('whats_new')),
            subtitle: Text(t.t('updates_hint')),
            onTap: () => Navigator.pushNamed(context, '/updates'),
          ),
          ListTile(
            leading: const Icon(IconlyLight.chart),
            title: Text(t.t('insights')),
            subtitle: Text(t.t('insights_entry')),
            onTap: () => Navigator.pushNamed(context, '/insights'),
          ),
          ListTile(
            leading: const Icon(IconlyLight.bag),
            title: Text(t.t('bundles')),
            onTap: () => Navigator.pushNamed(context, '/bundles'),
          ),
          ListTile(
            leading: const Icon(IconlyLight.video),
            title: Text(t.t('inspiration')),
            onTap: () => Navigator.pushNamed(context, '/inspiration'),
          ),
          ListTile(
            leading: const Icon(IconlyLight.location),
            title: Text(t.t('stores')),
            onTap: () => Navigator.pushNamed(context, '/stores'),
          ),
          ListTile(
            leading: const Icon(Icons.support_agent_outlined),
            title: Text(t.t('support')),
            onTap: () => Navigator.pushNamed(context, '/support'),
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
