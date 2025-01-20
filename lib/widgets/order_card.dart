// lib/widgets/order_card.dart
import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(order.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(order.description),
            Text('Customer ID: ${order.customerId}'),
            Text('Dabbawala ID: ${order.dabbawalaId}'), // Display dabbawalaId
            Text('Status: ${order.status}'), // Display status
          ],
        ),
      ),
    );
  }
}
