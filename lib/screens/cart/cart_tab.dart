import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '../../app.dart';
import '../../localization/app_localizations.dart';
import '../../widgets/primary_button.dart';

class CartTab extends StatefulWidget {
  const CartTab({super.key});

  @override
  State<CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  final TextEditingController codeCtrl = TextEditingController();

  @override
  void dispose() {
    codeCtrl.dispose();
    super.dispose();
  }

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
            AnimatedBuilder(
              animation: Listenable.merge([
                app.cartController.cartItems,
                app.promoController.appliedCoupon,
              ]),
              builder: (context, _) => _CartSummary(t: t, app: app, codeCtrl: codeCtrl),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final AppLocalizations t;
  final AppScope app;
  final TextEditingController codeCtrl;
  const _CartSummary({required this.t, required this.app, required this.codeCtrl});

  @override
  Widget build(BuildContext context) {
    final subtotal = app.cartController.subtotal;
    final discount = app.promoController.discountFor(subtotal);
    final total = subtotal + app.cartController.deliveryFee - discount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: codeCtrl,
          decoration: InputDecoration(
            labelText: t.t('promo_code'),
            suffixIcon: TextButton(
              onPressed: () {
                final success = app.promoController.applyCode(codeCtrl.text, subtotal);
                final key = app.promoController.lastError.value;
                final coupon = app.promoController.appliedCoupon.value;
                final minText = coupon?.minSpend.toStringAsFixed(0) ?? subtotal.toStringAsFixed(0);
                final message = success
                    ? t.t('coupon_applied')
                        .replaceFirst('{code}', coupon?.code ?? codeCtrl.text)
                        .replaceFirst('{value}', coupon?.percentageLabel() ?? '')
                    : t.t(key ?? 'invalid_coupon').replaceFirst('{min}', minText);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
              },
              child: Text(t.t('apply')),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/coupons'),
            icon: const Icon(IconlyLight.ticket),
            label: Text(t.t('browse_coupons')),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: app.promoController.appliedCoupon,
          builder: (context, coupon, _) {
            if (coupon == null) return const SizedBox.shrink();
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                child: const Icon(IconlyBold.ticket),
              ),
              title: Text(t.t('applied_coupon').replaceFirst('{code}', coupon.code)),
              subtitle: Text(coupon.localizedDescription(Localizations.localeOf(context))),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: app.promoController.clear,
              ),
            );
          },
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
              _row(t.t('subtotal'), subtotal),
              if (discount > 0) _row(t.t('discount'), -discount, highlight: true),
              _row(t.t('delivery_fee'), app.cartController.deliveryFee),
              const Divider(),
              _row(t.t('total'), total, bold: true),
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

  Widget _row(String label, double value, {bool bold = false, bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : null)),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : null,
              color: highlight ? Colors.green : null,
            ),
          ),
        ],
      ),
    );
  }
}
