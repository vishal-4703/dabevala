import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class card extends StatefulWidget {
  @override
  _cardState createState() => _cardState();
}

class _cardState extends State<card> {
  final DatabaseReference cartItemsRef = FirebaseDatabase.instance.ref().child('cartItems');
  double subtotal = 0.0;

  void calculateSubtotal() {
    cartItemsRef.once().then((DatabaseEvent event) {
      double total = 0.0;
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> cartItems = event.snapshot.value as Map<dynamic, dynamic>;
        cartItems.forEach((key, value) {
          int quantity = value['quantity'];
          double price = value['price'];
          total += quantity * price;
        });
      }
      setState(() {
        subtotal = total;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    calculateSubtotal();
  }

  Future<void> addItemToCart(String itemName, double price, String description, int quantity) async {
    await cartItemsRef.child(itemName).set({
      'name': itemName,
      'price': price,
      'description': description,
      'quantity': quantity,
    });
    calculateSubtotal();
  }

  Future<void> updateQuantity(String itemName, int quantity) async {
    await cartItemsRef.child(itemName).update({'quantity': quantity});
    calculateSubtotal();
  }

  Future<void> deleteItemFromCart(String itemName) async {
    await cartItemsRef.child(itemName).remove();
    calculateSubtotal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pushNamed(context, 'ProfilePage');
          },
        ),
        title: Text(
          'Shopping Cart',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                stream: cartItemsRef.onValue,
                builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.data!.snapshot.value == null) {
                    return Text('No items in the cart.');
                  }
                  Map<dynamic, dynamic> cartItems = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                  return Column(
                    children: cartItems.entries.map((entry) {
                      String key = entry.key;
                      Map<dynamic, dynamic> value = entry.value;
                      return _buildCartItem(
                        value['name'],
                        value['description'],
                        value['quantity'],
                        value['price'],
                            (quantity) => updateQuantity(key, quantity),
                            () => deleteItemFromCart(key),
                      );
                    }).toList(),
                  );
                },
              ),
              _buildSummary(subtotal),
              SizedBox(height: 20),
              _buildCheckoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartItem(
      String name,
      String description,
      int quantity,
      double price,
      ValueChanged<int> onQuantityChanged,
      VoidCallback onDelete,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  '₹${price.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          _buildQuantitySelector(quantity, onQuantityChanged),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(int quantity, ValueChanged<int> onQuantityChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.remove, color: Colors.grey),
          onPressed: () {
            if (quantity > 1) {
              onQuantityChanged(quantity - 1);
            }
          },
        ),
        Text(
          quantity.toString().padLeft(2, '0'),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        IconButton(
          icon: Icon(Icons.add, color: Colors.grey),
          onPressed: () {
            onQuantityChanged(quantity + 1);
          },
        ),
      ],
    );
  }

  Widget _buildSummary(double subtotal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSummaryRow('Subtotal', '₹${subtotal.toStringAsFixed(2)}'),
        _buildSummaryRow('Delivery Charges', '₹0.00'),
        _buildSummaryRow('Total Cost', '₹${subtotal.toStringAsFixed(2)}', isTotal: true),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isTotal ? Colors.black : Colors.grey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, 'payment');
      },
      child: Center(
        child: Text('Payment', style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}
