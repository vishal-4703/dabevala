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
        backgroundColor: Colors.white30,
        automaticallyImplyLeading: false,
        title: FadeInDown(
          child: Text(
            'Membership Plans',
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.black87, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: FadeInUp(
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 550,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 4),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                ),
                items: [
                  _buildPricingCard(
                    title: 'MONTHLY',
                    price: '₹3000',
                    color: Colors.teal.shade400,
                    features: ['Veg', 'Non Veg', 'Fast Delivery', 'Discounts'],
                    context: context,
                  ),
                  _buildPricingCard(
                    title: '3 MONTHS',
                    price: '₹8000',
                    color: Colors.blueAccent.shade200,
                    features: ['Veg', 'Non Veg', 'Premium Support', 'Extra Discounts'],
                    context: context,
                  ),
                  _buildPricingCard(
                    title: '6 MONTHS',
                    price: '₹15,000',
                    color: Colors.deepPurpleAccent.shade100,
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
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInDown(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 15),
            FadeInUp(
              child: Text(
                price,
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  color: Colors.yellowAccent,
                ),
              ),
            ),
            SizedBox(height: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: features.map((feature) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: SlideInLeft(
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.greenAccent),
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
                );
              }).toList(),
            ),
            SizedBox(height: 35),
            BounceInUp(
              child: ElevatedButton(
                onPressed: () => _saveSubscription(title, price, features, context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                ),
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
