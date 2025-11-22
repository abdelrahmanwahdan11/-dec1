import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../app.dart';
import '../../models/user_address.dart';
import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';
import '../../localization/app_localizations.dart';

class AddressBookScreen extends StatelessWidget {
  const AddressBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final locale = Localizations.localeOf(context);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.t('addresses')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ValueListenableBuilder<List<UserAddress>>(
              valueListenable: scope.addressController.addresses,
              builder: (context, addresses, _) {
                if (addresses.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        l10n.t('empty_addresses'),
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ).animate().fadeIn().slideY(begin: 0.1),
                    ),
                  );
                }
                return Expanded(
                  child: ListView.separated(
                    itemCount: addresses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final address = addresses[index];
                      final isDefault = address.isDefault;
                      return Dismissible(
                        key: ValueKey(address.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => scope.addressController.removeAddress(address.id),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: AppThemeBuilder.cardShadow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${address.label} • ${address.city}',
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                  ),
                                  if (isDefault)
                                    Chip(
                                      label: Text(l10n.t('default_address')),
                                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                                      labelStyle: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    )
                                  else
                                    TextButton(
                                      onPressed: () => scope.addressController.setDefault(address.id),
                                      child: Text(l10n.t('set_default')),
                                    )
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(address.name, style: Theme.of(context).textTheme.bodyLarge),
                              const SizedBox(height: 4),
                              Text(address.street, style: Theme.of(context).textTheme.bodyMedium),
                              const SizedBox(height: 4),
                              Text(address.phone, style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        ).animate().fadeIn(duration: 300.ms).slideX(begin: locale.languageCode == 'ar' ? 0.2 : -0.2),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: l10n.t('add_address'),
              onPressed: () => _showAddAddressSheet(context, scope),
            ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
          ],
        ),
      ),
    );
  }

  void _showAddAddressSheet(BuildContext context, AppScope scope) {
    final l10n = AppLocalizations.of(context);
    final labelController = TextEditingController();
    final cityController = TextEditingController();
    final streetController = TextEditingController();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    bool defaultValue = false;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: StatefulBuilder(
            builder: (context, setState) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.t('add_address'), style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 12),
                TextField(
                  controller: labelController,
                  decoration: InputDecoration(labelText: l10n.t('label_hint')),
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: l10n.t('full_name')),
                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: l10n.t('phone')),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: cityController,
                  decoration: InputDecoration(labelText: l10n.t('city')),
                ),
                TextField(
                  controller: streetController,
                  decoration: InputDecoration(labelText: l10n.t('street')),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: defaultValue,
                      onChanged: (value) => setState(() => defaultValue = value ?? false),
                    ),
                    Text(l10n.t('set_default')),
                  ],
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  label: l10n.t('save'),
                  onPressed: () {
                    final address = UserAddress(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      label: labelController.text.isEmpty ? l10n.t('addresses') : labelController.text,
                      name: nameController.text.isEmpty ? 'Plants Lover' : nameController.text,
                      phone: phoneController.text.isEmpty ? '+1 202-555-0100' : phoneController.text,
                      city: cityController.text.isEmpty ? 'Green City' : cityController.text,
                      street: streetController.text.isEmpty ? '12 Leafy Lane' : streetController.text,
                      isDefault: defaultValue,
                    );
                    scope.addressController.addAddress(address);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
