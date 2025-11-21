import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '../../data/mock_orders.dart';
import '../../localization/app_localizations.dart';
import '../../app.dart';
import '../../models/mock_order.dart';

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
                const SizedBox(height: 8),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton.icon(
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
                ),
              ],
            ),
          );
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
      case OrderStatus.shipped:
        return t.t('status_shipped');
      case OrderStatus.delivered:
        return t.t('status_delivered');
    }
  }
}
