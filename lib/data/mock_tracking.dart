import '../models/order_tracking_event.dart';
import '../models/mock_order.dart';

final mockTracking = <String, List<OrderTrackingEvent>>{
  'ORD-1001': [
    OrderTrackingEvent(
      checkpoint: OrderCheckpoint.placed,
      timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 6)),
      noteEn: 'Order received and validated.',
      noteAr: 'تم استلام الطلب والتحقق منه.',
    ),
    OrderTrackingEvent(
      checkpoint: OrderCheckpoint.packed,
      timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 2)),
      noteEn: 'Packed with insulated wrap to keep plants safe.',
      noteAr: 'تم التجهيز بمواد عازلة لحماية النباتات.',
    ),
    OrderTrackingEvent(
      checkpoint: OrderCheckpoint.shipped,
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 8)),
      noteEn: 'Handed to courier partner.',
      noteAr: 'تم التسليم لشركة الشحن.',
    ),
    OrderTrackingEvent(
      checkpoint: OrderCheckpoint.outForDelivery,
      timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      noteEn: 'Courier is approaching your area.',
      noteAr: 'المندوب يقترب من موقعك.',
    ),
  ],
  'ORD-1002': [
    OrderTrackingEvent(
      checkpoint: OrderCheckpoint.placed,
      timestamp: DateTime.now().subtract(const Duration(days: 9, hours: 4)),
      noteEn: 'Order received and validated.',
      noteAr: 'تم استلام الطلب والتحقق منه.',
    ),
    OrderTrackingEvent(
      checkpoint: OrderCheckpoint.packed,
      timestamp: DateTime.now().subtract(const Duration(days: 8, hours: 20)),
      noteEn: 'Packed with insulated wrap to keep plants safe.',
      noteAr: 'تم التجهيز بمواد عازلة لحماية النباتات.',
    ),
    OrderTrackingEvent(
      checkpoint: OrderCheckpoint.shipped,
      timestamp: DateTime.now().subtract(const Duration(days: 8, hours: 4)),
      noteEn: 'Handed to courier partner.',
      noteAr: 'تم التسليم لشركة الشحن.',
    ),
    OrderTrackingEvent(
      checkpoint: OrderCheckpoint.outForDelivery,
      timestamp: DateTime.now().subtract(const Duration(days: 7, hours: 20)),
      noteEn: 'Courier is approaching your area.',
      noteAr: 'المندوب يقترب من موقعك.',
    ),
    OrderTrackingEvent(
      checkpoint: OrderCheckpoint.delivered,
      timestamp: DateTime.now().subtract(const Duration(days: 7, hours: 16)),
      noteEn: 'Delivered to doorstep with signature.',
      noteAr: 'تم التوصيل حتى الباب مع توقيع.',
    ),
  ],
  'ORD-1003': [
    OrderTrackingEvent(
      checkpoint: OrderCheckpoint.placed,
      timestamp: DateTime.now().subtract(const Duration(hours: 14)),
      noteEn: 'Order received and validated.',
      noteAr: 'تم استلام الطلب والتحقق منه.',
    ),
    OrderTrackingEvent(
      checkpoint: OrderCheckpoint.packed,
      timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      noteEn: 'Packed with insulated wrap to keep plants safe.',
      noteAr: 'تم التجهيز بمواد عازلة لحماية النباتات.',
    ),
  ],
};

List<OrderTrackingEvent> trackingFor(MockOrder order) {
  return mockTracking[order.id] ?? const [];
}
