import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/dabbawala.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Dabbawala dabbawala;
  final List<Map<String, dynamic>> cartItems; // Cart items
  final double totalPrice; // Total price

  OrderDetailsScreen({
    required this.dabbawala,
    required this.cartItems, // Required parameter
    required this.totalPrice, // Required parameter
  });

  // Function to save the order to Firebase Realtime Database
  Future<void> _saveOrder(BuildContext context) async {
    try {
      // Get a reference to the Firebase Realtime Database
      final databaseRef = FirebaseDatabase.instance.ref();

      // Save the order to the "orders" node
      final orderRef = databaseRef.child('orders').push();
      await orderRef.set({
        'dabbawalaId': dabbawala.id, // ID of the assigned Dabbawala
        'orderId': orderRef.key, // Unique ID for the order
        'cartItems': cartItems, // List of cart items
        'totalPrice': totalPrice, // Total price of the order
        'status': 'Assigned', // Order status
        'timestamp': ServerValue.timestamp, // Timestamp of the order
      });

      // Update the Dabbawala's order count in the "dabbawalas" node
      final dabbawalaRef = databaseRef.child('dabbawalas').child(dabbawala.id);
      await dabbawalaRef.update({
        'orderCount': ServerValue.increment(1), // Increment the order count
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order assigned successfully!")),
      );

      // Navigate back to the previous screen
      Navigator.pop(context);
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to assign order: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade700, Colors.green.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          '${dabbawala.name} - Orders',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image (if applicable)
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/profile_placeholder.png'), // Replace with actual image
              backgroundColor: Colors.grey.shade300,
            ),
            SizedBox(height: 20),

            // Order Details Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(Icons.person, "Dabbawala Name", dabbawala.name),
                    _buildDetailRow(Icons.phone, "Contact", dabbawala.contact),
                    _buildDetailRow(Icons.assignment, "Active Orders", dabbawala.orderCount.toString()),
                    _buildDetailRow(Icons.shopping_cart, "Total Items", cartItems.length.toString()),
                    _buildDetailRow(Icons.attach_money, "Total Price", "₹${totalPrice.toStringAsFixed(2)}"),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            // Cart Items List
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          item['image'], // Replace with actual image path
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        item['name'],
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Price: ₹${item['price']}",
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                      trailing: Text(
                        "₹${item['price']}",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Save Order Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () => _saveOrder(context),
                icon: Icon(Icons.save, size: 20),
                label: Text("Assign Order"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            // Back Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back, size: 20),
                label: Text("Back"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.red.shade400, size: 24),
          SizedBox(width: 10),
          Text(
            "$label: ",
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}