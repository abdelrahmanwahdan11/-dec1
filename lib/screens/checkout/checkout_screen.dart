import 'package:flutter/material.dart';
import '../../widgets/primary_button.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Saved cards'),
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
              const Text('Add new card'),
              TextFormField(
                controller: holderCtrl,
                decoration: const InputDecoration(labelText: 'Card holder'),
                validator: (v) => v != null && v.isNotEmpty ? null : 'Required',
              ),
              TextFormField(
                controller: numberCtrl,
                decoration: const InputDecoration(labelText: 'Card number'),
                validator: (v) => v != null && v.length >= 12 ? null : 'Invalid',
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: expiryCtrl,
                      decoration: const InputDecoration(labelText: 'Expiry'),
                      validator: (v) => v != null && v.isNotEmpty ? null : 'Invalid',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: cvcCtrl,
                      decoration: const InputDecoration(labelText: 'CVC'),
                      validator: (v) => v != null && v.length >= 3 ? null : 'Invalid',
                    ),
                  ),
                ],
              ),
              CheckboxListTile(
                value: saveCard,
                onChanged: (val) => setState(() => saveCard = val ?? true),
                title: const Text('Save card for later'),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: 'Pay securely',
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
