import 'package:flutter/material.dart';
import 'mock_order.dart';

@immutable
class OrderTrackingEvent {
  final OrderCheckpoint checkpoint;
  final DateTime timestamp;
  final String noteEn;
  final String noteAr;

  const OrderTrackingEvent({
    required this.checkpoint,
    required this.timestamp,
    required this.noteEn,
    required this.noteAr,
  });

  String localizedNote(Locale locale) =>
      locale.languageCode == 'ar' ? noteAr : noteEn;
}

enum OrderCheckpoint {
  placed,
  packed,
  shipped,
  outForDelivery,
  delivered,
}

int checkpointIndex(OrderCheckpoint checkpoint) {
  switch (checkpoint) {
    case OrderCheckpoint.placed:
      return 0;
    case OrderCheckpoint.packed:
      return 1;
    case OrderCheckpoint.shipped:
      return 2;
    case OrderCheckpoint.outForDelivery:
      return 3;
    case OrderCheckpoint.delivered:
      return 4;
  }
}

int statusIndex(OrderStatus status) {
  switch (status) {
    case OrderStatus.processing:
      return 0;
    case OrderStatus.packed:
      return 1;
    case OrderStatus.shipped:
      return 2;
    case OrderStatus.outForDelivery:
      return 3;
    case OrderStatus.delivered:
      return 4;
  }
}
