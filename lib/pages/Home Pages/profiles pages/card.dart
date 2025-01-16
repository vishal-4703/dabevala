import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class card extends StatefulWidget {
  @override
  _cardState createState() => _cardState();
}

class _cardState extends State<card> {
  final CollectionReference cartItems =
  FirebaseFirestore.instance.collection('cartItems');

  double subtotal = 0.0;

  void calculateSubtotal() {
    cartItems.get().then((querySnapshot) {
      double total = 0.0;
      querySnapshot.docs.forEach((doc) {
        int quantity = doc['quantity'];
        double price = doc['price'];
        total += quantity * price;
      });
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

  Future<void> updateQuantity(String itemName, int quantity) async {
    await cartItems.doc(itemName).update({'quantity': quantity});
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
                stream: cartItems.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  return Column(
                    children: snapshot.data!.docs.map((doc) {
                      return _buildCartItem(
                        doc['imageUrl'],
                        doc['name'],
                        doc['description'],
                        doc['rating'],
                        doc['quantity'],
                        doc['price'],
                            (quantity) => updateQuantity(doc.id, quantity),
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
      String imageUrl, String name, String description, double rating, int quantity, double price,
      ValueChanged<int> onQuantityChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imageUrl, width: 100, height: 100),
          SizedBox(width: 16),
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
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 14),
                    SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: TextStyle(fontSize: 14, color: Colors.orange),
                    ),
                  ],
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
                fontSize: 14, color: isTotal ? Colors.black : Colors.grey),
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
