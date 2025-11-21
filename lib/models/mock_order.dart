import 'package:flutter/material.dart';
import 'cart_item.dart';

@immutable
class MockOrder {
  final String id;
  final List<CartItem> items;
  final double total;
  final DateTime date;

  const MockOrder({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
  });
}
