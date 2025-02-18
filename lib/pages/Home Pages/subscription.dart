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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: FadeInDown(
          child: Text(
            'Membership Plans',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 80),
            child: FadeInUp(
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 600,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 4),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 0.75,
                ),
                items: [
                  _buildPricingCard(
                    title: 'MONTHLY',
                    price: '₹3000',
                    color: Colors.teal.shade400,
                    features: ['Veg', 'Non-Veg', 'Fast Delivery', 'Special Discounts'],
                    context: context,
                  ),
                  _buildPricingCard(
                    title: '3 MONTHS',
                    price: '₹8000',
                    color: Colors.blueAccent.shade200,
                    features: ['Veg', 'Non-Veg', 'Premium Support', 'Extra Discounts'],
                    context: context,
                  ),
                  _buildPricingCard(
                    title: '6 MONTHS',
                    price: '₹15,000',
                    color: Colors.purpleAccent.shade100,
                    features: ['Priority Delivery', 'Exclusive Offers', 'VIP Support'],
                    context: context,
                  ),
                ],
              ),
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
        margin: EdgeInsets.symmetric(horizontal: 12),
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInDown(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            SizedBox(height: 20),
            FadeInUp(
              child: Text(
                price,
                style: GoogleFonts.poppins(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: features.map((feature) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: SlideInLeft(
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: color),
                        SizedBox(width: 10),
                        Text(
                          feature,
                          style: GoogleFonts.lato(
                            color: Colors.black87,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 40),
            BounceInUp(
              child: ElevatedButton(
                onPressed: () => _saveSubscription(title, price, features, context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 36),
                  elevation: 5,
                ),
                child: Text(
                  'SUBSCRIBE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
