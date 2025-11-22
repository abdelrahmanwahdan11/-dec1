import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/plant.dart';

class CartController {
  final ValueNotifier<List<CartItem>> cartItems = ValueNotifier<List<CartItem>>([]);

  void addToCart(Plant plant) {
    final items = List<CartItem>.from(cartItems.value);
    final index = items.indexWhere((c) => c.plant.id == plant.id);
    if (index >= 0) {
      items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
    } else {
      items.add(CartItem(plant: plant, quantity: 1));
    }
    cartItems.value = items;
  }

  void removeFromCart(String plantId) {
    cartItems.value = cartItems.value.where((item) => item.plant.id != plantId).toList();
  }

  void updateQuantity(String plantId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(plantId);
      return;
    }
    final items = cartItems.value.map((item) {
      if (item.plant.id == plantId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();
    cartItems.value = items;
  }

  double get subtotal =>
      cartItems.value.fold(0, (sum, item) => sum + item.plant.price * item.quantity);
  double get deliveryFee => cartItems.value.isEmpty ? 0 : 6.5;
  double get total => subtotal + deliveryFee;
}
