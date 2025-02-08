import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/dabbawala.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Dabbawala dabbawala;

  OrderDetailsScreen({required this.dabbawala});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade700, Colors.red.shade400],
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
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            // Back Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, size: 20),
              label: Text("Back"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
