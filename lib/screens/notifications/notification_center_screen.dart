import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';
import '../../app.dart';
import '../../localization/app_localizations.dart';
import '../../models/app_notification.dart';

class NotificationCenterScreen extends StatelessWidget {
  const NotificationCenterScreen({super.key});

  String _timeAgo(AppNotification notification, Locale locale) {
    final diff = DateTime.now().difference(notification.timestamp);
    final hours = diff.inHours;
    final days = diff.inDays;
    final code = locale.languageCode;
    if (hours < 1) return code == 'ar' ? 'الآن' : 'now';
    if (hours < 24) return code == 'ar' ? 'منذ $hours ساعة' : '${hours}h ago';
    return code == 'ar' ? 'منذ $days يوم' : '${days}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.t('notifications')),
        actions: [
          IconButton(
            icon: const Icon(IconlyLight.check),
            tooltip: t.t('mark_all_read'),
            onPressed: () => app.notificationsController.markAllRead(),
          ),
          IconButton(
            icon: const Icon(IconlyLight.delete),
            tooltip: t.t('clear_all'),
            onPressed: () => app.notificationsController.clearAll(),
          ),
        ],
      ),
      body: ValueListenableBuilder<List<AppNotification>>(
        valueListenable: app.notificationsController.notifications,
        builder: (context, items, _) {
          if (items.isEmpty) {
            return Center(child: Text(t.t('empty_notifications')));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final notification = items[index];
              final read = notification.read;
              return Container(
                decoration: BoxDecoration(
                  color: read
                      ? Theme.of(context).cardColor
                      : Theme.of(context).colorScheme.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                    child: Icon(
                      notification.id.contains('order')
                          ? IconlyBold.bag
                          : IconlyBold.activity,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  title: Text(notification.localizedTitle(locale.languageCode)),
                  subtitle: Text(notification.localizedBody(locale.languageCode)),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _timeAgo(notification, locale),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (!read)
                        TextButton(
                          onPressed: () => app.notificationsController.markRead(notification.id),
                          child: Text(t.t('mark_read')),
                        ),
                    ],
                  ),
                  onTap: () => app.notificationsController.markRead(notification.id),
                ),
              ).animate().fadeIn(duration: 200.ms).slide(begin: const Offset(0, 0.06));
            },
          );
        },
      ),
    );
  }
}
