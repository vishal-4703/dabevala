import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderService {
  Future<List<Order>> fetchOrders() async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    // Simulate fetching data from an API
    return [
      Order(id: 1, title: 'Order 1', description: 'Description for order 1', customerId: 'C001', dabbawalaId: 'D001', status: 'Delivered'),
      Order(id: 2, title: 'Order 2', description: 'Description for order 2', customerId: 'C002', dabbawalaId: 'D002', status: 'Pending'),
      // Add more sample orders here
    ];
  }
}
