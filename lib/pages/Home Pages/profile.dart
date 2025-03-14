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
  int? Id;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  void _fetchUserDetails() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      String userEmail = user.email ?? "";

      try {
        DatabaseEvent event = await _databaseReference.orderByChild("email").equalTo(userEmail).once();

        if (event.snapshot.value != null) {
          final data = Map<dynamic, dynamic>.from(event.snapshot.value as Map);
          data.forEach((key, value) {
            setState(() {
              Id = int.parse(key);
              _username = value["username"];
            });
            _fetchProfilePicture();
          });
        } else {
          setState(() => _username = 'User Not Found');
        }
      } catch (error) {
        setState(() => _username = 'Error fetching user');
      }
    } else {
      setState(() => _username = 'User Not Logged In');
    }
  }

  void _fetchProfilePicture() {
    if (Id != null) {
      _databaseReference.child(Id.toString()).child('profilePicture').onValue.listen((event) {
        if (event.snapshot.value != null) {
          setState(() => _imageUrl = event.snapshot.value.toString());
        }
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String fileName = "profile_${Id}.jpg";

      try {
        final uploadTask = _storage.ref().child('profilePictures/$fileName').putFile(imageFile);
        final snapshot = await uploadTask;
        final downloadUrl = await snapshot.ref.getDownloadURL();

        await _databaseReference.child(Id.toString()).update({'profilePicture': downloadUrl});
        setState(() => _imageUrl = downloadUrl);
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Profile', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: AnimatedContainer(
        duration: Duration(seconds: 2),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white,
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
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.grey.shade200,
                          child: CircleAvatar(
                            radius: 65,
                            backgroundImage: _imageUrl != null
                                ? NetworkImage(_imageUrl!)
                                : AssetImage('assets/profile.jpg') as ImageProvider,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _username,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          shadows: [Shadow(blurRadius: 2, color: Colors.grey, offset: Offset(1, 1))],
                        ),
                      ),
                      const SizedBox(height: 30),
                      buildMenuItem(context, Icons.notifications, 'Notifications', '3', 'NotificationsPage'),
                      buildMenuItem(context, Icons.lock, 'Password Update', '', 'forgetpassword'),
                      buildMenuItem(context, Icons.delivery_dining, 'RealTime Tracking', '', 'Realtime'),
                      buildMenuItem(context, Icons.home, 'Address', '', 'AddressPage'),
                      // buildMenuItem(context, Icons.card_membership, 'Membership Cards', '', 'sub'),
                      buildMenuItem(context, Icons.settings_suggest_outlined, 'About Us', '', 'AboutUsPage'),
                      buildMenuItem(context, Icons.logout_rounded, 'Log Out', '', 'logout'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(BuildContext context, IconData icon, String title, String badge, String routeName) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      color: Colors.white,
      shadowColor: Colors.grey.shade300,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade100,
          child: Icon(icon, color: Colors.black54),
        ),
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black)),
        trailing: badge.isNotEmpty
            ? Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
          child: Text(badge, style: TextStyle(color: Colors.white, fontSize: 12)),
        )
            : Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () => Navigator.pushNamed(context, routeName),
      ),
    );
  }
}
