import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SubscriptionDetailsPage extends StatefulWidget {
  @override
  _SubscriptionDetailsPageState createState() => _SubscriptionDetailsPageState();
}

class _SubscriptionDetailsPageState extends State<SubscriptionDetailsPage> {
  String? plan;
  String? price;
  List<String>? features;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSubscription();
  }

  void _fetchSubscription() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please log in to view subscription details")),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    DatabaseReference ref = FirebaseDatabase.instance.ref("subscriptions/${user.uid}");

    ref.get().then((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.value as Map;
        setState(() {
          plan = data['plan'];
          price = data['price'];
          features = List<String>.from(data['features'] ?? []);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching subscription: $error")),
      );
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: FadeInLeft(
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: FadeInDown(
          child: Text(
            'Subscription Details',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade900, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator(color: Colors.amberAccent)
              : plan == null
              ? FadeInUp(
            child: Text(
              "No subscription found!",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          )
              : GlassmorphicContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ZoomIn(
                  child: Text(
                    plan!,
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                FadeInRight(
                  child: Text(
                    '\$${price}',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      color: Colors.amberAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                ...features!.map((feature) => FadeInUp(
                  child: ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.greenAccent),
                    title: Text(
                      feature,
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
                    ),
                  ),
                )),
                SizedBox(height: 30),
                BounceInUp(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'payment');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amberAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                      shadowColor: Colors.black26,
                      elevation: 5,
                    ),
                    child: Pulse(
                      infinite: true,
                      child: Text(
                        'PROCEED TO PAYMENT',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  const GlassmorphicContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }
}
