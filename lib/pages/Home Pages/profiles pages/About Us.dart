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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.pinkAccent.shade200, Colors.deepPurple.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 80),
                      FadeInDown(
                        child: Text(
                          'About Us',
                          style: GoogleFonts.poppins(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      FadeInUp(
                        child: Text(
                          'Discover Our Passion for Food Delivery',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            FadeIn(
              duration: Duration(milliseconds: 800),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      'We are committed to redefining your food delivery experience with unmatched reliability and efficiency. Our platform connects you with your favorite meals from top-notch Dabbawala in record time.\n\n\nहम बेजोड़ विश्वसनीयता और दक्षता के साथ आपके भोजन वितरण अनुभव को फिर से परिभाषित करने के लिए प्रतिबद्ध हैं। हमारा प्लेटफ़ॉर्म आपको रिकॉर्ड समय में शीर्ष डब्बावाला से आपके पसंदीदा भोजन से जोड़ता है',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 35),
                    Divider(color: Colors.grey.shade400),
                    SizedBox(height: 25),
                    FadeInLeft(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.locationDot, color: Colors.deepPurple.shade400),
                          SizedBox(width: 10),
                          Text(
                            'Mumbai, India',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    FadeInRight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.phoneFlip, color: Colors.deepPurple.shade400),
                          SizedBox(width: 10),
                          Text(
                            '+91 7738395822',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 35),
                    JelloIn(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 10,
                        ),
                        onPressed: () async {
                          const phoneNumber = 'tel:+917738395822';
                          final Uri phoneUri = Uri.parse(phoneNumber);
                          if (await canLaunchUrl(phoneUri)) {
                            await launchUrl(phoneUri);
                          } else {
                            throw 'Could not launch $phoneNumber';
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                          child: Text(
                            'Contact Us',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 35),
                    FadeInUp(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.facebook, color: Colors.deepPurple.shade400, size: 35),
                          SizedBox(width: 25),
                          Icon(FontAwesomeIcons.twitter, color: Colors.deepPurple.shade400, size: 35),
                          SizedBox(width: 25),
                          Icon(FontAwesomeIcons.instagram, color: Colors.deepPurple.shade400, size: 35),
                          SizedBox(width: 25),
                          Icon(FontAwesomeIcons.linkedin, color: Colors.deepPurple.shade400, size: 35),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
