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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String _username = 'Loading...';
  String? _imageUrl;
  int? Id; // Store user ID

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  /// Fetches user details based on the logged-in email
  void _fetchUserDetails() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      String userEmail = user.email ?? "";
      print("Fetching details for: $userEmail");

      try {
        DatabaseEvent event = await _databaseReference.orderByChild("email").equalTo(userEmail).once();

        if (event.snapshot.value != null) {
          final data = Map<dynamic, dynamic>.from(event.snapshot.value as Map);

          data.forEach((key, value) {
            setState(() {
              Id = int.parse(key);  // Get the user ID
              _username = value["username"];
            });
            print("User found: $_username, ID: $Id");
            _fetchProfilePicture();
          });
        } else {
          setState(() {
            _username = 'User Not Found';
          });
        }
      } catch (error) {
        print("Error fetching user: $error");
        setState(() {
          _username = 'Error fetching user';
        });
      }
    } else {
      setState(() {
        _username = 'User Not Logged In';
      });
    }
  }

  /// Fetches Profile Picture if available
  void _fetchProfilePicture() {
    if (Id != null) {
      _databaseReference.child(Id.toString()).child('profilePicture').onValue.listen((event) {
        if (event.snapshot.value != null) {
          setState(() {
            _imageUrl = event.snapshot.value.toString();
          });
        }
      });
    }
  }

  /// Uploads a new Profile Picture to Firebase Storage
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String fileName = "profile_${Id}.jpg"; // Unique name using ID

      try {
        final uploadTask = _storage.ref().child('profilePictures/$fileName').putFile(imageFile);
        final snapshot = await uploadTask;
        final downloadUrl = await snapshot.ref.getDownloadURL();

        await _databaseReference.child(Id.toString()).update({
          'profilePicture': downloadUrl,
        });

        setState(() {
          _imageUrl = downloadUrl;
        });
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
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
                      // Profile Image Section
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage: _imageUrl != null
                              ? NetworkImage(_imageUrl!)
                              : AssetImage('assets/profile.jpg') as ImageProvider,
                          child: _imageUrl == null
                              ? Icon(Icons.camera_alt, size: 30, color: Colors.white)
                              : null,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Username
                      Text(
                        _username,
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Tap to change your profile picture',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      SizedBox(height: 30),

                      // Menu Items
                      buildMenuItem(context, Icons.notifications, 'Notifications', '3', () {
                        Navigator.pushNamed(context, 'NotificationsPage');
                      }),
                      buildMenuItem(context, Icons.lock, 'Password Update', null, () {
                        Navigator.pushNamed(context, 'forgetpassword');
                      }),
                      buildMenuItem(context, Icons.shopping_cart, 'shopping cart', null, () {
                        Navigator.pushNamed(context, 'CartPage');
                      }),
                      buildMenuItem(context, Icons.delivery_dining, 'RealTime Tracking', null, () {
                        Navigator.pushNamed(context, 'realtime');
                      }),
                      buildMenuItem(context, Icons.payment, 'Payment', null, () {
                        Navigator.pushNamed(context, 'payment');
                      }),
                      buildMenuItem(context, Icons.card_membership, 'Membership Cards', null, () {
                        Navigator.pushNamed(context, 'sub');
                      }),
                      buildMenuItem(context, Icons.settings_suggest_outlined, 'About Us', null, () {
                        Navigator.pushNamed(context, 'AboutUsPage');
                      }),
                    ],
                  ),
                ),
              ),
            ),

            // Logout Button
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
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(BuildContext context, IconData icon, String title, [String? badge, VoidCallback? onPressed]) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(fontSize: 18, color: Colors.white)),
      trailing: badge != null
          ? Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
        child: Text(badge, style: TextStyle(color: Colors.white, fontSize: 12)),
      )
          : Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
      onTap: onPressed,
    );
  }
}
