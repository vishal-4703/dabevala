import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = [];
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  // 🔹 Fetch Cart Items from Firebase
  void _fetchCartItems() async {
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
          cartRef.child(userId).once().then((cartSnapshot) {
            final cartData = cartSnapshot.snapshot.value;
            if (cartData != null) {
              Map<dynamic, dynamic> cartItemsMap = Map<dynamic, dynamic>.from(cartData as Map);
              setState(() {
                cartItems = cartItemsMap.values.map((item) {
                  return {
                    'name': item['name'],
                    'day': item['day'],
                    'price': item['price'],
                    'image': item['image'],
                    'key': cartItemsMap.keys.firstWhere((k) => cartItemsMap[k] == item), // Store the key
                  };
                }).toList();

                // Calculate the total price
                totalPrice = cartItems.fold(0.0, (sum, item) {
                  return sum + double.parse(item['price']);
                });
              });
            }
          });
        });
      }
    });
  }

  // 🔹 Handle Delete Item from Cart
  void _deleteItem(String itemKey) async {
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

          // 🔹 Delete the item from `cartItems/{userId}/{itemKey}`
          cartRef.child(userId).child(itemKey).remove().then((_) {
            setState(() {
              cartItems.removeWhere((item) => item['key'] == itemKey);  // Remove item from the list
              totalPrice = cartItems.fold(0.0, (sum, item) {
                return sum + double.parse(item['price']);
              });
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Item deleted from cart'),
                backgroundColor: Colors.red,
              ),
            );
          }).catchError((error) {
            print("Failed to delete item: $error");
          });
        });
      }
    });
  }

  // 🔹 Handle Payment
  void _handlePayment() {
    // Implement your payment processing logic here
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Processing'),
        content: Text('Your payment has been successfully processed!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to a confirmation or success page
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: cartItems.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // 🔹 Cart Items List
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return CartItemWidget(
                  item: item,
                  onDelete: () => _deleteItem(item['key']),  // Pass the key for deletion
                );
              },
            ),
          ),
          // 🔹 Total Price Display
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Price:',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '₹${totalPrice.toStringAsFixed(2)}',  // Display total price with 2 decimals
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          // 🔹 Payment Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'payment');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.deepPurple,
                elevation: 8,
              ),
              child: Text(
                'Proceed to Payment',
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
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onDelete;

  CartItemWidget({required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                item['image'],
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12),
            // Item Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    item['day'] != "N/A" ? 'Available on: ${item['day']}' : 'Available every day',
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '₹${item['price']}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,  // Calls the delete function passed from CartPage
            ),
          ],
        ),
      ),
    );
  }
}
