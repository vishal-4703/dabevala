import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final DatabaseReference _cartRef = FirebaseDatabase.instance.ref().child('cartItems');
  List<Map<String, dynamic>> cartItems = [];
  double totalPrice = 0.0; // Store total price

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
    _calculateTotalPrice();
  }

  void _fetchCartItems() {
    _cartRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> cartData = Map<dynamic, dynamic>.from(event.snapshot.value as Map);
        List<Map<String, dynamic>> newCartItems = [];

        cartData.forEach((key, value) {
          newCartItems.add({
            'key': key,
            'name': value['name'],
            'price': double.tryParse(value['price'].toString()) ?? 0.0,
            'day': value['day'],
            'image': value['image'],
          });
        });

        setState(() {
          cartItems = newCartItems;
        });

        _calculateTotalPrice();
      } else {
        setState(() {
          cartItems = [];
          totalPrice = 0.0;
        });
      }
    });
  }

  void _calculateTotalPrice() {
    _cartRef.onValue.listen((event) {
      double newTotal = 0.0;

      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> cartData = Map<dynamic, dynamic>.from(event.snapshot.value as Map);
        cartData.forEach((key, value) {
          newTotal += double.tryParse(value['price'].toString()) ?? 0.0;
        });
      }

      setState(() {
        totalPrice = newTotal;
      });
    });
  }

  void _removeFromCart(String itemKey) {
    _cartRef.child(itemKey).remove();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Item removed from cart"), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Cart",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade900,
      ),
      body: cartItems.isEmpty
          ? Center(
        child: Text(
          "Your cart is empty!",
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return Card(
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 5,
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: item['image'] != null && item['image'].isNotEmpty
                    ? (item['image'].startsWith('assets/')
                    ? Image.asset(
                  item['image'],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
                  },
                )
                    : Image.network(
                  item['image'],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
                  },
                ))
                    : Icon(Icons.image, size: 50, color: Colors.grey),
              ),
              title: Text(
                item['name'],
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "₹${item['price']} - ${item['day']}",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeFromCart(item['key']),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: cartItems.isNotEmpty
          ? Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Total Price Display
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Price:",
                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "₹${totalPrice.toStringAsFixed(2)}",
                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
            ),

            // Payment Button with Navigation
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'payment'); // Navigate to 'sub' screen
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.deepPurple.shade900,
              ),
              child: Center(
                child: Text(
                  "Payment",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
          : null,
    );
  }
}
