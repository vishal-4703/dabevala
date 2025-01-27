import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/customer.dart';
import '../widgets/customer_card.dart';

class CustomerListScreen extends StatefulWidget {
  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref("users");
  late Future<List<Customer>> _customersFuture;

  @override
  void initState() {
    super.initState();
    _customersFuture = fetchCustomers();
  }

  Future<List<Customer>> fetchCustomers() async {
    final snapshot = await _databaseRef.get();
    if (snapshot.exists) {
      final List<Customer> customers = [];
      snapshot.children.forEach((child) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(child.value as Map);
        customers.add(Customer.fromMap(data, child.key!)); // Pass both the map and the id (key)
      });
      return customers;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer List'),
      ),
      body: FutureBuilder<List<Customer>>(
        future: _customersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return buildLoading();
          } else if (snapshot.hasError) {
            return buildError(snapshot.error);
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return buildNoData();
          } else {
            return buildList(snapshot.data!);
          }
        },
      ),
    );
  }

  Widget buildLoading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget buildError(error) {
    return Center(child: Text('Error: $error'));
  }

  Widget buildNoData() {
    return Center(child: Text('No customers found.'));
  }

  Widget buildList(List<Customer> customers) {
    return ListView.builder(
      itemCount: customers.length,
      itemBuilder: (context, index) {
        return CustomerCard(customer: customers[index]);
      },
    );
  }
}
