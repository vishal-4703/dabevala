import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../usee_AUTH/firebase_auth_implemenation/firebase_auth_service.dart';

class signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<signup> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      User? user = await _auth.signUpWithEmailAndPassword(email, password);
      if (user != null) {
        DatabaseReference usersRef = FirebaseDatabase.instance.ref("users");
        DatabaseReference counterRef = FirebaseDatabase.instance.ref("lastId");

        int newId = 1;
        DataSnapshot snapshot = await counterRef.get();
        if (snapshot.exists) {
          newId = (snapshot.value as int) + 1;
        }

        // Store new user in Firebase
        await usersRef.child(newId.toString()).set({
          'id': newId,
          'username': username,
          'email': email,
          'createdAt': DateTime.now().toIso8601String(),
        });

        // Update the last used ID
        await counterRef.set(newId);

        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signup Successful!")));
        Navigator.pushNamed(context, 'login');
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      String errorMessage = e.code == 'email-already-in-use'
          ? "Email is already in use."
          : e.code == 'weak-password'
          ? "Password should be at least 6 characters."
          : "Signup failed, please try again.";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Screenshot 2025-02-15 135741.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),
          ),

          Positioned(
            top: 100,
            left: 50,
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Welcome Back Online \n Dabbawala System',
                  textStyle: GoogleFonts.poppins(
                    fontSize: 34,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [Colors.yellow, Colors.deepOrange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                    // shadows: [
                    //   Shadow(
                    //     blurRadius: 5.0,
                    //     color: Colors.black.withOpacity(0.5),
                    //     //offset: Offset(3.0, 3.0),
                    //   ),
                    //],
                  ),
                 // speed: Duration(milliseconds: 150),
                ),
              ],
              repeatForever: false,
            ),
          ),

          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Create Account",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildTextField("Username", _usernameController, Icons.person, false),
                    SizedBox(height: 15),
                    _buildTextField("Email", _emailController, Icons.email, false),
                    SizedBox(height: 15),
                    _buildTextField("Password", _passwordController, Icons.lock, true),
                    SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                    SizedBox(height: 15),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, 'login'),
                      child: Text("Already have an account? Login", style: TextStyle(color: Colors.white70)),
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

  Widget _buildTextField(String hint, TextEditingController controller, IconData icon, bool isPassword) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !_passwordVisible,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white70),
          onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
        )
            : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      ),
      validator: (value) => value!.isEmpty ? "Please enter your $hint" : null,
    );
  }
}
