import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';
import '../../app.dart';
import '../../data/mock_orders.dart';
import '../../data/mock_tracking.dart';
import '../../localization/app_localizations.dart';
import '../../models/mock_order.dart';
import '../../models/order_tracking_event.dart';

class TrackingScreen extends StatelessWidget {
  final String orderId;
  const TrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final order = mockOrders.firstWhere(
      (o) => o.id == orderId,
      orElse: () => mockOrders.first,
    );
    final events = trackingFor(order);
    final ratio = (statusIndex(order.status) + 1) / OrderCheckpoint.values.length;
    final eta = order.date.add(const Duration(days: 5));
    final locale = AppScope.of(context).localeController.locale;

    return Scaffold(
      appBar: AppBar(
        title: Text('${t.t('track_order')} #${order.id}'),
        actions: [
          IconButton(
            icon: const Icon(IconlyLight.notification),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _TrackingHeader(order: order, ratio: ratio, eta: eta, t: t),
          const SizedBox(height: 16),
          Text(t.t('tracking_updates'), style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...events.asMap().entries.map(
            (entry) {
              final index = entry.key;
              final event = entry.value;
              final completed = checkpointIndex(event.checkpoint) <= statusIndex(order.status);
              return _TimelineTile(
                event: event,
                completed: completed,
                isLast: index == events.length - 1,
                locale: locale,
              ).animate(delay: (index * 80).ms).fadeIn(duration: 320.ms).slideX(begin: -0.1, end: 0);
            },
          ),
          if (events.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(t.t('track_hint')),
            ),
        ],
      ),
    );
  }
}

class _TrackingHeader extends StatelessWidget {
  final MockOrder order;
  final double ratio;
  final DateTime eta;
  final AppLocalizations t;

  const _TrackingHeader({
    required this.order,
    required this.ratio,
    required this.eta,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(IconlyBold.location),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.t('order_timeline'), style: Theme.of(context).textTheme.titleMedium),
                    Text(t.t('track_hint'), style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Chip(label: Text('${(ratio * 100).toStringAsFixed(0)}%')),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              minHeight: 12,
              value: ratio.clamp(0.0, 1.0),
            ),
          ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_month_outlined),
              const SizedBox(width: 8),
              Text('${t.t('estimated_delivery')}: ${eta.year}-${eta.month.toString().padLeft(2, '0')}-${eta.day.toString().padLeft(2, '0')}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  final OrderTrackingEvent event;
  final bool completed;
  final bool isLast;
  final Locale locale;

  const _TimelineTile({
    required this.event,
    required this.completed,
    required this.isLast,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final color = completed ? Theme.of(context).colorScheme.primary : Colors.grey;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            AnimatedContainer(
              duration: 260.ms,
              curve: Curves.easeOut,
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: completed ? color : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: color, width: 2),
              ),
              child: completed ? const Icon(Icons.check, color: Colors.white, size: 12) : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 48,
                color: color.withOpacity(0.3),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_checkpointLabel(context), style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(event.localizedNote(locale)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 16),
                    const SizedBox(width: 6),
                    Text('${event.timestamp.hour.toString().padLeft(2, '0')}:${event.timestamp.minute.toString().padLeft(2, '0')}'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _checkpointLabel(BuildContext context) {
    final t = AppLocalizations.of(context);
    switch (event.checkpoint) {
      case OrderCheckpoint.placed:
        return t.t('checkpoint_placed');
      case OrderCheckpoint.packed:
        return t.t('checkpoint_packed');
      case OrderCheckpoint.shipped:
        return t.t('checkpoint_shipped');
      case OrderCheckpoint.outForDelivery:
        return t.t('checkpoint_out_for_delivery');
      case OrderCheckpoint.delivered:
        return t.t('checkpoint_delivered');
    }
  }
}
