import 'package:flutter/material.dart';
import 'plant.dart';

@immutable
class CartItem {
  final Plant plant;
  final int quantity;

  const CartItem({required this.plant, required this.quantity});

  CartItem copyWith({Plant? plant, int? quantity}) =>
      CartItem(plant: plant ?? this.plant, quantity: quantity ?? this.quantity);
}
