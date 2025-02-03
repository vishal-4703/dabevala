import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.ref().child('users').child('users');
  String _username = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  void _fetchUsername() {
    _databaseReference.child('username').once().then((DatabaseEvent event) {
      setState(() {
        _username = event.snapshot.value as String;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white38,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushNamed(context, 'FoodGoHomePage');
          },
        ),
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.white70,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: AssetImage('assets/profile.jpg'),
                        ),
                        SizedBox(height: 10),
                        Text(
                          _username, // Display fetched username
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  buildMenuItem(
                      context, Icons.notifications, 'Notifications', '3', () {
                    Navigator.pushNamed(context, '');
                  }),
                  buildMenuItem(
                      context, Icons.lock, 'Password Update', null, () {
                    Navigator.pushNamed(context, 'restPage');
                  }),
                  buildMenuItem(
                      context, Icons.shopping_cart, 'Shopping Cart', null, () {
                    Navigator.pushNamed(context, 'card');
                  }),
                  buildMenuItem(
                      context, Icons.delivery_dining, ' RealTime Tracking', null, () {
                    Navigator.pushNamed(context, 'realtime');
                  }),
                  buildMenuItem(
                      context, Icons.payment, 'Payment', null, () {
                    Navigator.pushNamed(context, 'payment');
                  }),
                  buildMenuItem(context, Icons.card_membership,
                      'Membership Cards', null, () {
                        Navigator.pushNamed(context, 'sub');
                      }),
                  buildMenuItem(
                      context, Icons.settings_suggest_outlined, 'About Us', null, () {
                    Navigator.pushNamed(context, '');
                  }),
                ],
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'logout');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Log out',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 20), // Add spacing below the button if needed
        ],
      ),
    );
  }

  Widget buildMenuItem(BuildContext context, IconData icon, String title,
      [String? badge, VoidCallback? onPressed]) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Colors.grey),
        title: Text(title),
        trailing: badge != null && badge.isNotEmpty
            ? Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            badge,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        )
            : Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onPressed,
      ),
    );
  }
}
