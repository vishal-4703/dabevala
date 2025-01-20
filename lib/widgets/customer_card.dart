import 'package:flutter/material.dart';
import '../models/customer.dart';

class CustomerCard extends StatelessWidget {
  final Customer customer;

  CustomerCard({required this.customer});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(customer.name),
        subtitle: Text('${customer.address}\n${customer.contact}'),
      ),
    );
  }
}
