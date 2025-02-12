import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cart_page.dart';

class NextPage extends StatelessWidget {
  final String itemName;
  final String day;
  final String price;
  final String assetImagePath;

  NextPage({
    required this.itemName,
    required this.day,
    required this.price,
    required this.assetImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          itemName,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // 🔹 Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade900, Colors.blue],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // 🔹 Main Content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GlassContainer(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🔹 Animated Image
                    Hero(
                      tag: assetImagePath,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          assetImagePath,
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // 🔹 Item Name
                    Text(
                      itemName,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    if (day != "N/A")
                      Text(
                        'Available on: $day',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),

                    SizedBox(height: 8),

                    // 🔹 Price
                    Text(
                      '₹$price',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent,
                      ),
                    ),

                    SizedBox(height: 20),

                    // 🔹 Add to Cart Button
                    ElevatedButton(
                      onPressed: () {
                        _addToCart(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.white,
                        elevation: 8,
                      ),
                      child: Text(
                        'Add to Cart',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Function to Fetch User ID & Add Item to Cart
  void _addToCart(BuildContext context) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String userEmail = user.email ?? "";
    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');
    DatabaseReference cartRef = FirebaseDatabase.instance.ref().child('cartItems');

    // 🔹 Find the User ID from `users` table using Email
    usersRef.orderByChild("email").equalTo(userEmail).once().then((event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null) {
        Map<dynamic, dynamic> userData = Map<dynamic, dynamic>.from(dataSnapshot.value as Map);
        userData.forEach((key, value) {
          String userId = value['id'].toString();
          String newCartItemKey = cartRef.child(userId).push().key ?? "";

          // 🔹 Add Item to `cartItems/{userId}`
          cartRef.child(userId).child(newCartItemKey).set({
            'name': itemName,
            'day': day,
            'price': price,
            'image': assetImagePath,
          }).then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$itemName added to cart'),
                backgroundColor: Colors.green,
              ),
            );

            // Navigate to Cart Page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartPage()),
            );
          }).catchError((error) {
            print("Failed to add item: $error");
          });
        });
      }
    });
  }
}

// 🔹 Glassmorphism Effect Widget
class GlassContainer extends StatelessWidget {
  final Widget child;
  const GlassContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }
}
