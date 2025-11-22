import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';
import '../../data/mock_orders.dart';
import '../../data/mock_tracking.dart';
import '../../localization/app_localizations.dart';
import '../../app.dart';
import '../../models/mock_order.dart';
import '../../models/order_tracking_event.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final app = AppScope.of(context);
    final locale = app.localeController.locale;
    return Scaffold(
      appBar: AppBar(title: Text(t.t('orders'))),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final order = mockOrders[index];
          final events = trackingFor(order);
          final locale = app.localeController.locale;
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(IconlyBold.bag),
                    const SizedBox(width: 8),
                    Text(order.id, style: Theme.of(context).textTheme.titleMedium),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${t.t('order_date')}: ${formatOrderDate(order.date)}'),
                        const SizedBox(height: 4),
                        Chip(label: Text('${t.t('order_status')}: ${_statusLabel(order.status, t)}')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _OrderProgressBar(status: order.status, events: events, t: t),
                const SizedBox(height: 12),
                ...order.items.map((item) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(item.plant.imageUrl, width: 56, height: 56, fit: BoxFit.cover),
                      ),
                      title: Text(item.plant.localizedName(locale)),
                      subtitle: Text('${item.quantity} x \$${item.plant.price.toStringAsFixed(2)}'),
                    )),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(t.t('total'), style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text('\$${order.total.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  alignment: WrapAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.timeline),
                      label: Text(t.t('track_order')),
                      onPressed: () => Navigator.pushNamed(context, '/tracking', arguments: order.id),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: Text(t.t('reorder')),
                      onPressed: () {
                        for (final item in order.items) {
                          for (var i = 0; i < item.quantity; i++) {
                            app.cartController.addToCart(item.plant);
                          }
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(t.t('added_to_cart'))),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(duration: 350.ms, delay: (index * 80).ms).slideY(begin: 0.1, end: 0);
        },
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: mockOrders.length,
      ),
    );
  }

  String _statusLabel(OrderStatus status, AppLocalizations t) {
    switch (status) {
      case OrderStatus.processing:
        return t.t('status_processing');
      case OrderStatus.packed:
        return t.t('status_packed');
      case OrderStatus.shipped:
        return t.t('status_shipped');
      case OrderStatus.outForDelivery:
        return t.t('status_out_for_delivery');
      case OrderStatus.delivered:
        return t.t('status_delivered');
    }
  }
}

class _OrderProgressBar extends StatelessWidget {
  final OrderStatus status;
  final List<OrderTrackingEvent> events;
  final AppLocalizations t;

  const _OrderProgressBar({
    required this.status,
    required this.events,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = (statusIndex(status) + 1) / OrderCheckpoint.values.length;
    final latestNote = events.isNotEmpty ? events.last.localizedNote(AppScope.of(context).localeController.locale) : t.t('track_hint');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(t.t('order_progress'), style: Theme.of(context).textTheme.bodyMedium),
            Text('${(ratio * 100).toStringAsFixed(0)}%'),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            minHeight: 10,
            value: ratio.clamp(0.0, 1.0),
          ),
        ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.local_shipping, size: 18),
            const SizedBox(width: 6),
            Expanded(child: Text(latestNote, style: Theme.of(context).textTheme.bodySmall)),
          ],
        ),
      ],
    );
  }
}
