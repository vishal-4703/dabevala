import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_glow/flutter_glow.dart';

class FoodDeliveryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Gradient Overlay and Parallax Effect
          Positioned.fill(
            child: AnimatedContainer(
              duration: Duration(seconds: 2),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/homepage.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Animated Content
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                BounceInDown(
                  duration: Duration(milliseconds: 800),
                  child: GlowText(
                    'Fast delivery of delicious food',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 10, color: Colors.white)],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                FadeInUp(
                  duration: Duration(milliseconds: 1000),
                  child: Text(
                    'Order food within 30 min and get bonuses.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Dots Indicator with Glow Animation
                FadeInUp(
                  duration: Duration(milliseconds: 1200),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GlowingDot(isActive: false),
                      GlowingDot(isActive: true),
                      GlowingDot(isActive: false),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                // Get Started Button with Enhanced Animation
                FadeInUp(
                  duration: Duration(milliseconds: 1400),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'FoodGoHomePage');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 12,
                      shadowColor: Colors.purpleAccent,
                    ),
                    child: GlowText(
                      '____नमस्ते तुमचे स्वागत आहे____',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Animated Glowing Dot
class GlowingDot extends StatelessWidget {
  final bool isActive;

  GlowingDot({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: isActive ? 14 : 12,
      width: isActive ? 14 : 12,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey,
        shape: BoxShape.circle,
        boxShadow: isActive
            ? [BoxShadow(color: Colors.white, blurRadius: 15)]
            : [],
      ),
    );
  }
}
