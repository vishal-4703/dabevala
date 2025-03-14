import 'package:flutter/material.dart';
import 'dabbawala_list_screen.dart'; // Import the DabbawalaListScreen

class PaymentDetailsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;

  PaymentDetailsScreen({required this.cartItems, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Confirmation'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Icon(Icons.check_circle, size: 100, color: Colors.teal),
                  SizedBox(height: 20),
                  Text(
                    'Payment Successful!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Transaction Number: 123456789',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 10),
            Text("Items Purchased:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return ListTile(
                    title: Text(item["name"], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Price: ₹${item["price"]}"),
                    trailing: Text("₹${item["price"]}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                  );
                },
              ),
            ),
            Divider(),
            SizedBox(height: 10),
            Text(
              "Total Amount: ₹${totalPrice.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 10),
            Text(
              "Paid with Razorpay",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            SizedBox(height: 20), // Space before the button
            // Assign Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to DabbawalaListScreen and pass data
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DabbawalaListScreen(
                        cartItems: cartItems, // Pass cart items
                        totalPrice: totalPrice, // Pass total price
                      ),
                    ),
                  );
                },
                child: Text(
                  'Assign',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: Size(double.infinity, 50), // Full-width button
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}