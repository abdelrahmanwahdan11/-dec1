import '../models/cart_item.dart';
import '../models/mock_order.dart';
import 'mock_plants.dart';

final mockOrders = [
  MockOrder(
    id: 'ORD-1001',
    items: [
      CartItem(plant: mockPlants[0], quantity: 1),
      CartItem(plant: mockPlants[2], quantity: 2),
    ],
    total: mockPlants[0].price + mockPlants[2].price * 2,
    date: DateTime.now().subtract(const Duration(days: 3)),
  ),
  MockOrder(
    id: 'ORD-1002',
    items: [
      CartItem(plant: mockPlants[1], quantity: 1),
      CartItem(plant: mockPlants[3], quantity: 1),
    ],
    total: mockPlants[1].price + mockPlants[3].price,
    date: DateTime.now().subtract(const Duration(days: 9)),
  ),
];

String formatOrderDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}
