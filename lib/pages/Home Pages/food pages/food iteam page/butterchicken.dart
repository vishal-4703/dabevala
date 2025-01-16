import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class butterchicken extends StatelessWidget {
  final DatabaseReference database = FirebaseDatabase.instance.ref();

  void addToCart() {
    database.child('cart').push().set({
      'name': 'Butter Chicken',
      'price': 150,
      'description': 'Butter Chicken ',
      'quantity': 1,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF000000)),
          onPressed: () {
            Navigator.pushNamed(context, 'nonveg');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Color(0xFF000000)),
            onPressed: () {
              Navigator.pushNamed(context, 'card');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    spreadRadius: 4,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/butterchicken.png', // Path to your local image asset
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Butter Chicken',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Icon(Icons.star, color: Color(0xFFF2C94C));
              }),
            ),
            SizedBox(height: 10),
            Text(
              '₹ 150',
              style: TextStyle(
                fontSize: 24,
                color: Color(0xFF0223FA),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Butter Chicken',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF828282),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                addToCart();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added Butter Chicken to cart!'),
                  ),
                );
                Navigator.pushNamed(context, 'card');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0333F4),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Add to Cart',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
