import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class forgetpassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: FadeInLeft(
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: FadeInDown(
          child: Text(
            'FORGET PASSWORD',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 1.5,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Center(
                child: BounceInDown(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.purpleAccent, Colors.deepPurple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurpleAccent.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.lock_outline,
                      size: 120,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ZoomIn(
                child: _buildGlassmorphismTextField('Current Password', Icons.lock),
              ),
              SizedBox(height: 20),
              ZoomIn(
                delay: Duration(milliseconds: 300),
                child: _buildGlassmorphismTextField('New Password', Icons.lock_outline),
              ),
              SizedBox(height: 20),
              ZoomIn(
                delay: Duration(milliseconds: 600),
                child: _buildGlassmorphismTextField('Confirm New Password', Icons.lock_reset),
              ),
              SizedBox(height: 40),
              Center(
                child: JelloIn(
                  delay: Duration(milliseconds: 800),
                  child: _buildGradientButton(context),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Swing(
                  delay: Duration(milliseconds: 1000),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Need Help?',
                      style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassmorphismTextField(String label, IconData icon) {
    return FadeInUp(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurpleAccent.withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 3,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.black, fontSize: 16),
            prefixIcon: Icon(icon, color: Colors.black),
            filled: true,
            fillColor: Colors.transparent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildGradientButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'forgetpassword2'),
      child: Bounce(
        delay: Duration(milliseconds: 500),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.purpleAccent.withOpacity(0.6),
                blurRadius: 20,
                offset: Offset(0, 5),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            'UPDATE PASSWORD',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
