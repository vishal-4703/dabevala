import 'package:flutter/material.dart';

class logout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // Set the background color to white
      appBar: AppBar(
        backgroundColor: Colors.white,  // Semi-transparent background for the app bar
        elevation: 1,  // Add subtle elevation for the app bar
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),  // Back button icon
          onPressed: () {
            Navigator.pushNamed(context, 'ProfilePage');  // Navigate to 'FoodGoHomePage'
          },
        ),
        title: Text(
          '',  // Title for the app bar
          style: TextStyle(color: Colors.black),  // Title color set to black
        ),
        centerTitle: true,  // Center the title in the app bar
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Displaying the image from the URL
              Image.network(
                'https://storage.googleapis.com/a1aa/image/bdYsepq1klXMXKAyTpLb9Ob6pKOSf9Re43gS8QTe0pHsa3aPB.jpg',
                height: 150,
              ),
              SizedBox(height: 20),
              // Logout header text
              Text(
                'LOG OUT',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              // Additional information text
              Text(
                'Your Logout has been successfully',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              // Continue button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'login');  // Navigate to login page
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  elevation: 0,
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'CONTINUE',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}