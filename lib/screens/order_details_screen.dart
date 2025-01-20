import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Order order;

  OrderDetailsScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Order ID: ${order.id}'),
            Text('Customer ID: ${order.customerId}'),
            Text('Dabbawala ID: ${order.dabbawalaId}'),
            Text('Status: ${order.status}'),
          ],
        ),
      ),
    );
  }
}
