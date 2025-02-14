import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated Gradient Background with Animation Effect
          AnimatedContainer(
            duration: Duration(seconds: 3),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade900, Colors.indigo.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: FadeInLeft(
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Center(
            child: AnimatedOpacity(
              duration: Duration(seconds: 1),
              opacity: _opacity,
              child: BounceInDown(
                duration: Duration(milliseconds: 800),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 0.2), // Updated
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15,
                          spreadRadius: 3,
                        ),
                      ],
                      border: Border.all(color: Color.fromRGBO(255, 255, 255, 0.3)), // Updated
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Swing(
                                duration: Duration(milliseconds: 1000),
                                child: Text(
                                  'About Us',
                                  style: GoogleFonts.poppins(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              FadeIn(
                                duration: Duration(milliseconds: 1200),
                                child: Text(
                                  'We are dedicated to delivering the best food delivery experience. Our mission is to connect customers with their favorite restaurants and ensure fast and reliable delivery services.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: Color.fromRGBO(255, 255, 255, 0.9), // Updated
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Divider(color: Color.fromRGBO(255, 255, 255, 0.5)), // Updated
                              SizedBox(height: 15),
                              FadeInLeft(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(FontAwesomeIcons.locationDot, color: Colors.white), // Updated
                                    SizedBox(width: 8),
                                    Text(
                                      'Mumbai, India',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              FadeInRight(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(FontAwesomeIcons.phoneFlip, color: Colors.white), // Updated
                                    SizedBox(width: 8),
                                    Text(
                                      '+91 7738395822',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              JelloIn(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromRGBO(255, 255, 255, 0.3), // Updated
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: () async {
                                    const phoneNumber = 'tel:+917738395822';
                                    final Uri phoneUri = Uri.parse(phoneNumber); // Updated
                                    if (await canLaunchUrl(phoneUri)) { // Updated
                                      await launchUrl(phoneUri); // Updated
                                    } else {
                                      throw 'Could not launch $phoneNumber';
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                                    child: Text(
                                      'Contact Us',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              SlideInLeft(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(FontAwesomeIcons.facebook, color: Colors.white, size: 30),
                                    SizedBox(width: 15),
                                    Icon(FontAwesomeIcons.twitter, color: Colors.white, size: 30),
                                    SizedBox(width: 15),
                                    Icon(FontAwesomeIcons.instagram, color: Colors.white, size: 30),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}