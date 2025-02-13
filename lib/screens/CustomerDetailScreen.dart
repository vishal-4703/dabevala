import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';
import '../models/customer.dart';
import 'CartItemsScreen.dart';

class CustomerDetailScreen extends StatelessWidget {
  final Customer customer;

  CustomerDetailScreen({required this.customer});

  Future<bool> isLottieAvailable() async {
    try {
      String data = await rootBundle.loadString('assets/animations/');
      return data.isNotEmpty;
    } catch (e) {
      print("Lottie Animation Error: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(
          customer.username.isNotEmpty ? customer.username : "Unknown User",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FadeInDown(
            child: GlassContainer(
              borderRadius: BorderRadius.circular(30),
              blur: 20,
              opacity: 0.2,
              child: Card(
                elevation: 20,
                shadowColor: Colors.blue.shade400,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Hero(
                        tag: customer.username,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
                          backgroundColor: Colors.grey.shade300,
                          child: Icon(Icons.person, size: 60, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElasticIn(
                        child: Text(
                          customer.username.isNotEmpty ? customer.username : "Unknown User",
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      FadeInLeft(
                        child: Text(
                          customer.email.isNotEmpty ? customer.email : "No Email Provided",
                          style: GoogleFonts.poppins(fontSize: 18, color: Colors.black87),
                        ),
                      ),
                      SizedBox(height: 20),
                      FutureBuilder<bool>(
                        future: isLottieAvailable(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError || snapshot.data == false) {
                            return Text(
                              "Order Details",
                              style: GoogleFonts.poppins(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold),
                            );
                          } else {
                            return Lottie.asset(
                              'assets/animations/customer_info.json',
                              height: 100,
                            );
                          }
                        },
                      ),
                      SizedBox(height: 25),
                      ZoomIn(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to the CartItemsScreen and pass the userId
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CartItemsScreen(userId: customer.id), // Pass the userId
                              ),
                            );
                          },
                          icon: Icon(Icons.arrow_forward_ios,),
                          label: Text("Order",style: GoogleFonts.poppins(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 35),
                            shadowColor: Colors.blue.shade700,
                            iconColor: Colors.white,
                            elevation: 10,
                          ),
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
    );
  }
}

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius borderRadius;

  GlassContainer({
    required this.child,
    this.blur = 20.0,
    this.opacity = 0.2,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity),
            borderRadius: borderRadius,
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}
