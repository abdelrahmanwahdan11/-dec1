import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '../../app.dart';
import '../../localization/app_localizations.dart';
import '../../widgets/primary_button.dart';

class CartTab extends StatelessWidget {
  const CartTab({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: app.cartController.cartItems,
                builder: (context, items, _) {
                  if (items.isEmpty) {
                    return Center(child: Text(t.t('empty_cart')));
                  }
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(item.plant.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                        ),
                        title: Text(item.plant.nameEn),
                        subtitle: Text('\$${item.plant.price.toStringAsFixed(2)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(IconlyLight.delete),
                              onPressed: () => app.cartController.removeFromCart(item.plant.id),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => app.cartController
                                  .updateQuantity(item.plant.id, item.quantity - 1),
                            ),
                            Text(item.quantity.toString()),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => app.cartController
                                  .updateQuantity(item.plant.id, item.quantity + 1),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            _CartSummary(t: t, app: app),
          ],
        ),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final AppLocalizations t;
  final AppScope app;
  const _CartSummary({required this.t, required this.app});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: t.t('promo_code'),
            suffixIcon: TextButton(onPressed: () {}, child: Text(t.t('apply'))),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _row(t.t('subtotal'), app.cartController.subtotal),
              _row(t.t('delivery_fee'), app.cartController.deliveryFee),
              const Divider(),
              _row(t.t('total'), app.cartController.total, bold: true),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          label: t.t('pay'),
          onPressed: () => Navigator.pushNamed(context, '/checkout'),
        ),
      ],
    );
  }

  Widget _row(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : null)),
          Text('\$${value.toStringAsFixed(2)}', style: TextStyle(fontWeight: bold ? FontWeight.bold : null)),
        ],
      ),
    );
  }
}
