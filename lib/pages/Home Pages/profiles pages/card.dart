import 'package:flutter/material.dart';

class card extends StatefulWidget {
  @override
  _cardState createState() => _cardState();
}
class _cardState extends State<card> {
  int Quantity = 1;
  int DalQuantity = 1;
  int chanaQuantity = 1;
  int aaluQuantity = 1;
  int pannerQuantity = 1;
  int soyabinQuantity = 1;

  double get subtotal {
    return (Quantity * 150 +
        Quantity * 130 +
        Quantity * 120 +
        Quantity * 150 +
        Quantity * 120 +
       Quantity * 150);

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
            crossAxisAlignment: CrossAxisAlignment.start, // Align items to the left
            children: [
              _buildCartItem(
                'assets/sun.jpg', // Replace with actual image paths
                'Shai Panner',
                'Delicious Indian food VEG',
                4.5,
                Quantity,
                    (newQuantity) => setState(() => Quantity = newQuantity),
              ),
              _buildCartItem(
                'assets/mon.webp',
                'Dal Chawal Puri',
                'Classic Indian food VEG',
                4.2,
                Quantity,
                    (newQuantity) => setState(() => Quantity = newQuantity),
              ),
              _buildCartItem(
                'assets/tue.webp',
                'Chana Masala Roti Rice',
                'Freshly Indian food VEG',
                4.8,
               Quantity,
                    (newQuantity) => setState(() => Quantity = newQuantity),
              ),
              _buildCartItem(
                'assets/wed.jpg',
                'Aalu Roti Rice',
                'Golden french Indian food VEG',
                4.1,
                Quantity,
                    (newQuantity) => setState(() => Quantity = newQuantity),
              ),
              _buildCartItem(
                'assets/thu.jpg',
                'Panner Roti Rice',
                'Golden french Indian food VEG',
                4.1,
                Quantity,
                    (newQuantity) => setState(() => Quantity = newQuantity),
              ),
              _buildCartItem(
                'assets/fri.jpg',
                'Soyabin Roti Rice',
                'Freshly french Indian food VEG',
                4.1,
                Quantity,
                    (newQuantity) => setState(() => Quantity = newQuantity),
              ),
              SizedBox(height: 16),
              _buildSummary(subtotal),
              SizedBox(height: 16),
              _buildCheckoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartItem(
      String imageUrl, String name, String description, double rating, int quantity,
      ValueChanged<int> onQuantityChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imageUrl, width: 100, height: 100), // Adjust image size
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
      crossAxisAlignment: CrossAxisAlignment.start, // Align items to the left
      children: [
        _buildSummaryRow('Subtotal', '\₹${subtotal.toStringAsFixed(2)}'),
        _buildSummaryRow('Delivery Charges', '\₹0.00'),
        _buildSummaryRow('Total Cost', '\₹${subtotal.toStringAsFixed(2)}', ),
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

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  SummaryRow({required this.label, required this.value, this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: isTotal ? Colors.black : Colors.grey)),
          Text(value, style: TextStyle(fontSize: isTotal ? 16 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: isTotal ? Colors.black : Colors.grey)),
        ],
      ),
    );
  }
}
