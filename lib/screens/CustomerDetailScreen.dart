import 'package:flutter/material.dart';
import '../models/customer.dart';

class CustomerDetailScreen extends StatelessWidget {
  final Customer customer;

  CustomerDetailScreen({required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(customer.username),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${customer.username}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Email: ${customer.email}', style: TextStyle(fontSize: 16)),
            // Add more customer details as needed
          ],
        ),
      ),
    );
  }
}
