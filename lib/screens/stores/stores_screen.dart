import 'package:flutter/material.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final branches = [
      ('Downtown', '123 Green St', '9am - 8pm'),
      ('Uptown', '55 Palm Ave', '10am - 9pm'),
      ('Harbor', '9 Seaside Rd', '9am - 7pm'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Stores')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',
            ),
          ),
          const SizedBox(height: 12),
          ...branches.map(
            (b) => ListTile(
              leading: const Icon(Icons.store_mall_directory_outlined),
              title: Text(b.$1),
              subtitle: Text('${b.$2} • ${b.$3}'),
            ),
          ),
        ],
      ),
    );
  }
}
