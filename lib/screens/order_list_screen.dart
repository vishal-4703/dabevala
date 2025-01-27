import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class OrderListScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(Map<String, dynamic>) onRemoveFromCart;

  OrderListScreen({
    required this.cartItems,
    required this.onRemoveFromCart,
  });

  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('User  Cart');
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    try {
      databaseReference.onValue.listen((event) {
        List<Map<String, dynamic>> fetchedCartItems = [];
        final dataSnapshot = event.snapshot;
        if (dataSnapshot.value != null) {
          Map<dynamic, dynamic> values = Map<dynamic, dynamic>.from(dataSnapshot.value as Map);
          values.forEach((key, value) {
            fetchedCartItems.add({
              'id': key,
              'name': value['name'],
              'price': value['price'],
              'day': value['day'],
              'imagePath': value['imagePath'],
              'description': value['description'],
            });
          });
        }
        setState(() {
          widget.cartItems.clear();
          widget.cartItems.addAll(fetchedCartItems);
          isLoading = false;
        });
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load cart items.";
        isLoading = false;
      });
    }
  }

  double calculateTotal() {
    return widget.cartItems.fold(0.0, (total, item) => total + (double.tryParse(item['price']) ?? 0.0));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }

    double totalAmount = calculateTotal();

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        backgroundColor: Color(0xFF0333F4), // Primary color
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center the column content
        children: [
          Expanded(
            child: Center( // Center the ListView
              child: ListView.builder(
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  final item = widget.cartItems[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: Image.asset(item['imagePath'], width: 50, height: 50),
                      title: Text(item['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Day: ${item['day']}\nPrice: ₹${item['price']}', style: TextStyle(color: Colors.grey[600])),
                      // Removed the delete button
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total: ₹$totalAmount',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0333F4)),
            ),
          ),
          // Removed the Proceed to Payment button
        ],
      ),
    );
  }

  void _removeFromCart(Map<String, dynamic> item) {
    setState(() {
      widget.cartItems.remove(item);
    });
    deleteItemFromDatabase(item['id']);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item['name']} removed from cart')),
    );
  }

  void deleteItemFromDatabase(String itemId) {
    databaseReference.child(itemId).remove().then((_) {
      print("Item deleted successfully.");
    }).catchError((error) {
      print("Failed to delete item: $error");
    });
  }
}