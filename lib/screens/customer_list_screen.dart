import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/customer.dart';
import 'CustomerDetailScreen.dart';
// Import the CustomerDetailScreen

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
        customers.add(Customer.fromMap(data, child.key!));
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
        automaticallyImplyLeading: false, // Removes the back button
        title: Text('Customer List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _customersFuture = fetchCustomers(); // Refresh the data
              });
            },
          )
        ],
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
    return Center(child: Text('Error: $error', style: TextStyle(color: Colors.red)));
  }

  Widget buildNoData() {
    return Center(child: Text('No customers found.', style: TextStyle(color: Colors.grey)));
  }

  Widget buildList(List<Customer> customers) {
    return ListView.builder(
      itemCount: customers.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(customers[index].username, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: Text(customers[index].email, style: TextStyle(fontSize: 14, color: Colors.grey)),
              trailing: Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
              onTap: () {
                // Navigate to the detailed page of the selected customer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerDetailScreen(customer: customers[index]),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
