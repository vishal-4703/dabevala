import 'package:flutter/material.dart';

class sub extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Disable the debug banner

      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushNamed(context, 'FoodGoHomePage');
            },
          ),
          title: Text('Membership'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Set the scroll direction to horizontal
              child: Row(

                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  PricingCard(
                    title: 'WEEKLY',
                    price: '\799',
                    features: [
                      'Veg',
                      'Non Veg',
                      'Veg',
                      'Non Veg',
                      'Veg',
                    ],
                    availableFeatures: [true, true, true, false, false],
                    color: Colors.pink,
                  ),
                  SizedBox(width: 16), // Add space between the cards
                  PricingCard(
                    title: 'MONTHLY',
                    price: '\2999',
                    features: [
                      'Veg',
                      'Non Veg',
                      'Veg',
                      'Non Veg',
                      'Non Veg',
                    ],
                    availableFeatures: [true, true, true, true, false],
                    color: Colors.blue,
                  ),
                  SizedBox(width: 16), // Add space between the cards
                  PricingCard(
                    title: '3 MONTH',
                    price: '\7999',
                    features: [
                      'Veg',
                      'Non Veg',
                      'Non Veg',
                      'Non Veg',
                      'Non Veg',
                    ],
                    availableFeatures: [true, true, true, true, true],
                    color: Colors.purple,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PricingCard extends StatelessWidget {
  final String title;
  final String price;
  final List<String> features;
  final List<bool> availableFeatures;
  final Color color;

  PricingCard({
    required this.title,
    required this.price,
    required this.features,
    required this.availableFeatures,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 880,
      width: 400, // Set the width for each card
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 30),
          Text(
            price,
            style: TextStyle(
              color: Colors.white,
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'per month',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 40),
          Column(
            children: List.generate(features.length, (index) {
              return Row(
                children: [
                  Icon(
                    availableFeatures[index]
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      features[index],
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
          SizedBox(height: 400),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              foregroundColor: color,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: Text('SUBSCRIBE'),
          ),
        ],
      ),
    );

  }
}
