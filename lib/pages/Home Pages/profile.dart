import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref().child('users');
  String _username = 'Loading...';
  String? _imageUrl;
  final User? _user = FirebaseAuth.instance.currentUser; // Get current user
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  void _fetchUsername() {
    if (_user != null) {
      _databaseReference.child(_user!.uid).child('username').onValue.listen((event) {
        if (event.snapshot.value != null) {
          setState(() {
            _username = event.snapshot.value.toString();
          });
        } else {
          setState(() {
            _username = 'No Username Found';
          });
        }
      });
      _databaseReference.child(_user!.uid).child('profilePicture').onValue.listen((event) {
        if (event.snapshot.value != null) {
          setState(() {
            _imageUrl = event.snapshot.value.toString();
          });
        }
      });
    } else {
      setState(() {
        _username = 'User Not Logged In';
      });
    }
  }

  // Method to pick image and upload it to Firebase Storage
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Get the file path and upload it to Firebase Storage
      File imageFile = File(pickedFile.path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString(); // Unique name
      try {
        // Upload to Firebase Storage
        final uploadTask = _storage.ref().child('profilePictures/$fileName').putFile(imageFile);
        final snapshot = await uploadTask;
        final downloadUrl = await snapshot.ref.getDownloadURL();

        // Update the profile image URL in the Firebase Database
        await _databaseReference.child(_user!.uid).update({
          'profilePicture': downloadUrl,
        });

        // Update the image locally
        setState(() {
          _imageUrl = downloadUrl;  // Update the UI with the new image
        });
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
  }

  Future<String?> _getImageUrl() async {
    if (_user != null) {
      final snapshot = await _databaseReference.child(_user!.uid).child('profilePicture').get();
      return snapshot.value != null ? snapshot.value.toString() : null;
    }
    return null;  // Return null if no URL found
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, 'FoodGoHomePage');
          },
        ),
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage, // Open image picker when tapped
                        child: FutureBuilder<String?>(
                          future: _getImageUrl(), // Fetch image URL from Firebase
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircleAvatar(
                                radius: 70,
                                backgroundColor: Colors.grey,
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError || snapshot.data == null) {
                              return CircleAvatar(
                                radius: 70,
                                backgroundImage: AssetImage('assets/profile.jpg'),
                              );
                            } else {
                              return CircleAvatar(
                                radius: 70,
                                backgroundImage: NetworkImage(snapshot.data!),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        _username,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Tap to change your profile picture',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      SizedBox(height: 30),
                      buildMenuItem(
                        context,
                        Icons.notifications,
                        'Notifications',
                        '3',
                            () {} ,
                      ),
                      buildMenuItem(
                        context,
                        Icons.lock,
                        'Password Update',
                        null,
                            () {
                          Navigator.pushNamed(context, 'restPage');
                        },
                      ),
                      buildMenuItem(
                        context,
                        Icons.delivery_dining,
                        'RealTime Tracking',
                        null,
                            () {
                          Navigator.pushNamed(context, 'realtime');
                        },
                      ),
                      buildMenuItem(
                        context,
                        Icons.payment,
                        'Payment',
                        null,
                            () {
                          Navigator.pushNamed(context, 'payment');
                        },
                      ),
                      buildMenuItem(
                        context,
                        Icons.card_membership,
                        'Membership Cards',
                        null,
                            () {
                          Navigator.pushNamed(context, 'sub');
                        },
                      ),
                      buildMenuItem(
                        context,
                        Icons.settings_suggest_outlined,
                        'About Us',
                        null,
                            () {} ,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'logout');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Log out',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20), // Add spacing below the button if needed
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(BuildContext context, IconData icon, String title,
      [String? badge, VoidCallback? onPressed]) {
    return Container(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
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
            : Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
        onTap: onPressed,
      ),
    );
  }
}
