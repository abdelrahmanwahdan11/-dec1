import 'package:flutter/material.dart';
import 'cart_item.dart';

enum OrderStatus { processing, shipped, delivered }

@immutable
class MockOrder {
  final String id;
  final List<CartItem> items;
  final double total;
  final DateTime date;
  final OrderStatus status;

  const MockOrder({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
    this.status = OrderStatus.processing,
  });
}
