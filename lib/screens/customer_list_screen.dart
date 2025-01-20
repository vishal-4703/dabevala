import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../services/customer_service.dart';
import '../widgets/customer_card.dart';

class CustomerListScreen extends StatelessWidget {
  final CustomerService customerService = CustomerService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer List'),
      ),
      body: FutureBuilder(
        future: customerService.fetchCustomers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Customer> customers = snapshot.data ?? [];
            return ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                return CustomerCard(customer: customers[index]);
              },
            );
          }
        },
      ),
    );
  }
}
