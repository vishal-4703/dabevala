import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class logout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFEAE9ED), Color(0xFF958989)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Main content
          Center(
            child: FadeInDown(
              duration: Duration(seconds: 2),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Image with bounce effect
                    BounceInDown(
                      duration: Duration(seconds: 2),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 80,
                          backgroundImage: NetworkImage(
                            'https://storage.googleapis.com/a1aa/image/bdYsepq1klXMXKAyTpLb9Ob6pKOSf9Re43gS8QTe0pHsa3aPB.jpg',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),

                    // Logout text with slide animation
                    SlideInLeft(
                      duration: Duration(milliseconds: 1500),
                      child: Text(
                        'LOG OUT',
                        style: GoogleFonts.poppins(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Success message with fade-in effect
                    FadeInUp(
                      duration: Duration(seconds: 2),
                      child: Text(
                        'You have successfully logged out.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                    ),

                    SizedBox(height: 50),

                    // Continue button with ripple effect
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'login');
                      },
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                          gradient: LinearGradient(
                            colors: [Color(0xFFE100FF), Color(0xFF7F00FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'CONTINUE',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    // Subtle animated icon
                    FadeIn(
                      duration: Duration(seconds: 3),
                      child: Icon(
                        Icons.exit_to_app,
                        size: 40,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
