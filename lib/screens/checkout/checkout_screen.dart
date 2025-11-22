import 'package:flutter/material.dart';
import '../../app.dart';
import '../../localization/app_localizations.dart';
import '../../widgets/primary_button.dart';
import '../../models/user_address.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final holderCtrl = TextEditingController();
  final numberCtrl = TextEditingController();
  final expiryCtrl = TextEditingController();
  final cvcCtrl = TextEditingController();
  bool saveCard = true;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t.t('checkout'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder<List<UserAddress>>(
                valueListenable: app.addressController.addresses,
                builder: (context, addresses, _) {
                  final address = app.addressController.defaultAddress;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_pin, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: address == null
                              ? Text(t.t('empty_addresses'))
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(t.t('shipping_address'),
                                        style: Theme.of(context).textTheme.titleMedium),
                                    const SizedBox(height: 4),
                                    Text(address.name, style: Theme.of(context).textTheme.bodyLarge),
                                    Text(address.street),
                                    Text(address.city),
                                    Text(address.phone),
                                  ],
                                ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/addresses'),
                          child: Text(
                            addresses.isEmpty
                                ? t.t('add_address')
                                : t.t('manage_addresses'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              Text(t.t('saved_cards'), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              SizedBox(
                height: 140,
                child: PageView(
                  children: const [
                    _MockCard(title: 'Visa', last4: '1234'),
                    _MockCard(title: 'Mastercard', last4: '5678'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(t.t('add_card'), style: Theme.of(context).textTheme.titleMedium),
              TextFormField(
                controller: holderCtrl,
                decoration: InputDecoration(labelText: t.t('card_holder')),
                validator: (v) => v != null && v.isNotEmpty ? null : t.t('apply'),
              ),
              TextFormField(
                controller: numberCtrl,
                decoration: InputDecoration(labelText: t.t('card_number')),
                validator: (v) => v != null && v.length >= 12 ? null : t.t('apply'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: expiryCtrl,
                      decoration: InputDecoration(labelText: t.t('expiry')),
                      validator: (v) => v != null && v.isNotEmpty ? null : t.t('apply'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: cvcCtrl,
                      decoration: InputDecoration(labelText: t.t('cvc')),
                      validator: (v) => v != null && v.length >= 3 ? null : t.t('apply'),
                    ),
                  ),
                ],
              ),
              CheckboxListTile(
                value: saveCard,
                onChanged: (val) => setState(() => saveCard = val ?? true),
                title: Text(t.t('save_card')),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _totalRow(t.t('subtotal'), app.cartController.subtotal, context),
                    _totalRow(t.t('delivery_fee'), app.cartController.deliveryFee, context),
                    const Divider(),
                    _totalRow(t.t('total'), app.cartController.total, context, bold: true),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: t.t('pay_securely'),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    Navigator.pushNamed(context, '/success');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _totalRow(String label, double value, BuildContext context, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: bold ? FontWeight.w600 : null)),
          Text('\$${value.toStringAsFixed(2)}',
              style: TextStyle(
                  fontWeight: bold ? FontWeight.w700 : null,
                  color: bold ? Theme.of(context).colorScheme.primary : null)),
        ],
      ),
    );
  }
}

class _MockCard extends StatelessWidget {
  final String title;
  final String last4;
  const _MockCard({required this.title, required this.last4});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const Spacer(),
          Text('•••• •••• •••• $last4', style: const TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }
}
