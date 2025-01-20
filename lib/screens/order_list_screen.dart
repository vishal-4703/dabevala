import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/order_service.dart';
import '../widgets/order_card.dart';


class OrderListScreen extends StatelessWidget {
  final OrderService orderService = OrderService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order List'),
      ),
      body: FutureBuilder(
        future: orderService.fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Order> orders = snapshot.data ?? [];
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return OrderCard(order: orders[index]);
              },
            );
          }
        },
      ),
    );
  }
}
