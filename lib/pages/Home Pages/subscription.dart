import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class sub extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade900,
      appBar: AppBar(
        leading: FadeInLeft(
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, 'FoodGoHomePage');
            },
          ),
        ),
        title: FadeInDown(
          child: Text(
            'Membership',
            style: GoogleFonts.lato(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: FadeInUp(
            child: CarouselSlider(
              options: CarouselOptions(
                height: 500,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
              ),
              items: [
                BounceInLeft(
                  child: _buildPricingCard(
                    title: 'MONTHLY',
                    price: '₹3000',
                    color: Colors.blueAccent.shade700,
                    features: ['Veg', 'Non Veg', 'Fast Delivery', 'Discounts'],
                    context: context,
                  ),
                ),
                BounceInRight(
                  child: _buildPricingCard(
                    title: '3 MONTH',
                    price: '₹8000',
                    color: Colors.blueAccent,
                    features: ['Veg', 'Non Veg', 'Premium Support', 'Extra Discounts'],
                    context: context,
                  ),
                ),
                BounceInRight(
                  child: _buildPricingCard(
                    title: '6 MONTH',
                    price: '₹15,000',
                    color: Colors.lightBlue,
                    features: ['Priority Delivery', 'Exclusive Offers', 'VIP Support'],
                    context: context,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPricingCard({
    required String title,
    required String price,
    required Color color,
    required List<String> features,
    required BuildContext context,
  }) {
    return ZoomIn(
      child: Container(
        width: 320,
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeInDown(
              child: Text(
                title,
                style: GoogleFonts.lato(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 15),
            FadeInUp(
              child: Text(
                price,
                style: GoogleFonts.lato(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: features
                  .map(
                    (feature) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: SlideInLeft(
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.amberAccent),
                        SizedBox(width: 10),
                        Text(
                          feature,
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  .toList(),
            ),
            SizedBox(height: 40),
            BounceInUp(
              child: ElevatedButton(
                onPressed: () {
                  _saveSubscription(title, price, features, context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                  shadowColor: Colors.black26,
                ),
                child: Pulse(
                  infinite: true,
                  child: Text(
                    'SUBSCRIBE',
                    style: TextStyle(
                      color: color,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveSubscription(String plan, String price, List<String> features, BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please log in to subscribe")),
      );
      return;
    }

    DatabaseReference ref = FirebaseDatabase.instance.ref("subscriptions/${user.uid}");

    ref.set({
      "plan": plan,
      "price": price,
      "features": features,
      "timestamp": DateTime.now().toIso8601String(),
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Subscription successful!")),
      );
      Navigator.pushNamed(context, 'SubscriptionDetailsPage');
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to subscribe: $error")),
      );
    });
  }
}
