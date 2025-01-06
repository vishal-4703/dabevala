import 'package:flutter/material.dart';

class FoodDeliveryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/homepage.jpg'), //background image
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Text Content
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Text(
                'Fast delivery of delicious food',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Order food within 30 min and get bonuses.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              // Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Dot(isActive: false),
                  Dot(isActive: true),
                  Dot(isActive: false),
                ],
              ),
              SizedBox(height: 20),
              // Get Started Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'FoodGoHomePage');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text(
                  '____नमस्ते तुमचे स्वागत आहे____',
                  style: TextStyle(
                    color: Colors.white,
                      fontWeight: FontWeight.bold
                ),
              ),
              )],
          ),
        ),
      ],
    );
  }
}

class Dot extends StatelessWidget {
  final bool isActive;

  Dot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
