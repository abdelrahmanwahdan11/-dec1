import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_address.dart';

class AddressController extends ChangeNotifier {
  static const _storageKey = 'saved_addresses';
  final ValueNotifier<List<UserAddress>> addresses = ValueNotifier<List<UserAddress>>([]);

  AddressController() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_storageKey);
    if (stored != null && stored.isNotEmpty) {
      addresses.value = stored.map((e) => UserAddress.fromJson(e)).toList();
    } else {
      addresses.value = [
        UserAddress(
          id: 'addr-1',
          label: 'Home',
          name: 'Plants Lover',
          phone: '+1 202-555-0123',
          city: 'Green City',
          street: '12 Leafy Lane',
          isDefault: true,
        ),
        UserAddress(
          id: 'addr-2',
          label: 'Office',
          name: 'Plants Lover',
          phone: '+1 202-555-0174',
          city: 'Fresh District',
          street: '88 Botanical Blvd',
        ),
      ];
      await _persist();
    }
  }

  Future<void> addAddress(UserAddress address) async {
    final list = List<UserAddress>.from(addresses.value);
    if (address.isDefault) {
      for (var i = 0; i < list.length; i++) {
        list[i] = list[i].copyWith(isDefault: false);
      }
    }
    list.insert(0, address);
    addresses.value = list;
    notifyListeners();
    await _persist();
  }

  Future<void> removeAddress(String id) async {
    final list = List<UserAddress>.from(addresses.value)..removeWhere((a) => a.id == id);
    if (!list.any((a) => a.isDefault) && list.isNotEmpty) {
      list[0] = list[0].copyWith(isDefault: true);
    }
    addresses.value = list;
    notifyListeners();
    await _persist();
  }

  Future<void> setDefault(String id) async {
    final list = List<UserAddress>.from(addresses.value);
    for (var i = 0; i < list.length; i++) {
      list[i] = list[i].copyWith(isDefault: list[i].id == id);
    }
    addresses.value = list;
    notifyListeners();
    await _persist();
  }

  UserAddress? get defaultAddress {
    final list = addresses.value;
    final match = list.where((a) => a.isDefault);
    if (match.isNotEmpty) return match.first;
    if (list.isNotEmpty) return list.first;
    return null;
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _storageKey,
      addresses.value.map((e) => e.toJson()).toList(),
    );
  }

  @override
  void dispose() {
    addresses.dispose();
    super.dispose();
  }
}
