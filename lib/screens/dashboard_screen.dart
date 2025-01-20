import 'package:flutter/material.dart';
import 'package:your_project_name/pages/login%20pages/login.dart';
import 'dabbawala_list_screen.dart';
import 'order_list_screen.dart';
import 'customer_list_screen.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Define a common button style
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Dabbawala Admin Dashboard'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome to the Dabbawala Admin Dashboard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                ElevatedButton.icon(
                  icon: Icon(Icons.list, size: 24),
                  label: Text('Dabbawala List', style: TextStyle(fontSize: 18)),
                  style: buttonStyle,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DabbawalaListScreen()),
                    );
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Icon(Icons.receipt, size: 24),
                  label: Text('Order List', style: TextStyle(fontSize: 18)),
                  style: buttonStyle,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrderListScreen()),
                    );
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Icon(Icons.person, size: 24),
                  label: Text('Customer List', style: TextStyle(fontSize: 18)),
                  style: buttonStyle,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CustomerListScreen()),
                    );
                  },
                ),
                Spacer(), // Add spacer to push the logout button to the bottom
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.logout, size: 24),
                    label: Text('Logout', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent, // Logout button color
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => login()),
                      );
                    },
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
