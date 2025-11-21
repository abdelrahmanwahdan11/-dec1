import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '../../data/mock_orders.dart';
import '../../localization/app_localizations.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
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
                    Text(formatOrderDate(order.date)),
                  ],
                ),
                const SizedBox(height: 12),
                ...order.items.map((item) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(item.plant.imageUrl, width: 56, height: 56, fit: BoxFit.cover),
                      ),
                      title: Text(item.plant.nameEn),
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
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: mockOrders.length,
      ),
    );
  }
}
