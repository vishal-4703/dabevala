// lib/models/order.dart
class Order {
  final int id;
  final String title;
  final String description;
  final String customerId;
  final String dabbawalaId; // Add this line
  final String status; // Add this line

  Order({
    required this.id,
    required this.title,
    required this.description,
    required this.customerId,
    required this.dabbawalaId, // Add this line
    required this.status, // Add this line
  });
}
