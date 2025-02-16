import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'profiles pages/NextPage.dart';
import 'cart_page.dart';
import 'subscription.dart';
import 'profile.dart';

class FoodGoHomePage extends StatefulWidget {
  @override
  _FoodGoHomePageState createState() => _FoodGoHomePageState();
}

class _FoodGoHomePageState extends State<FoodGoHomePage> {
  int _selectedIndex = 0;
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('MenuItems');

  List<Map<String, dynamic>> _todaysOffer = [];
  List<Map<String, dynamic>> _offers = [];
  List<Map<String, dynamic>> _popular = [];

  @override
  void initState() {
    super.initState();
    _fetchMenuItems();
  }

  void _fetchMenuItems() {
    _database.onValue.listen((event) {
      List<Map<String, dynamic>> todaysOffer = [];
      List<Map<String, dynamic>> offers = [];
      List<Map<String, dynamic>> popular = [];

      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null) {
        Map<dynamic, dynamic> values = Map<dynamic, dynamic>.from(dataSnapshot.value as Map);
        values.forEach((key, value) {
          Map<String, dynamic> menuItem = {
            'id': key,
            'itemName': value['itemName'] ?? 'Default Item',
            'category': value['category']?.toString().toLowerCase() ?? '',
            'price': value['price'] ?? '0',
            'day': value['day'] ?? 'N/A',
            'discount': value['discount'] ?? 'No Discount',
            'assetImagePath': value['assetImagePath'] ?? 'assets/default_image.png'
          };
          if (menuItem['category'] == 'todays offer') {
            todaysOffer.add(menuItem);
          } else if (menuItem['category'] == 'offers') {
            offers.add(menuItem);
          } else if (menuItem['category'] == 'popular') {
            popular.add(menuItem);
          }
        });
      }
      setState(() {
        _todaysOffer = todaysOffer;
        _offers = offers;
        _popular = popular;
      });
    });
  }

  List<Widget> get _pages => [
    HomeContent(todaysOffer: _todaysOffer, offers: _offers, popular: _popular),
    sub(),
    CartPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text('DABBAWALA', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.lightBlue,
        elevation: 4,
        actions: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: Padding(
              padding: EdgeInsets.only(right: 16),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/profile.jpg'),
                radius: 22,
              ),
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex].animate().fade(duration: 600.ms).slideY(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, 'MenuPage'),
        child: Icon(Icons.fastfood, color: Colors.white),
        backgroundColor: Colors.deepOrange,
        elevation: 6,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      buttonBackgroundColor: Colors.lightBlue,
      color: Colors.lightBlue,
      height: 60,
      animationDuration: Duration(milliseconds: 400),
      items: <Widget>[
        Icon(Icons.home, size: 30, color: Colors.white),
        Icon(Icons.card_membership, size: 30, color: Colors.white),
        Icon(Icons.shopping_cart, size: 30, color: Colors.white),
        Icon(Icons.person, size: 30, color: Colors.white),
      ],
      onTap: _onItemTapped,
    );
  }
}

// Home Page Content
class HomeContent extends StatelessWidget {
  final List<Map<String, dynamic>> todaysOffer;
  final List<Map<String, dynamic>> offers;
  final List<Map<String, dynamic>> popular;

  HomeContent({required this.todaysOffer, required this.offers, required this.popular});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text('Hey!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))
                .animate().fade().scale(duration: 500.ms),
            SizedBox(height: 5),
            Text('Let\'s get your order', style: TextStyle(color: Colors.grey, fontSize: 16))
                .animate().fade(duration: 400.ms),
            SizedBox(height: 15),

            // Search Bar
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search our delicious Food',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              ),
            ).animate().fade(duration: 600.ms),

            SizedBox(height: 20),
            _buildCategoryList(context, '🌟 Today\'s Offer', todaysOffer),
            SizedBox(height: 20),
            _buildCategoryList(context, '🎉 Special Offers', offers),
            SizedBox(height: 20),
            _buildCategoryList(context, '🍽️ Popular Dishes', popular),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context, String title, List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
            .animate().fade(duration: 500.ms),
        SizedBox(height: 10),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _buildFoodCard(items[index], context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFoodCard(Map<String, dynamic> item, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(item['assetImagePath'], width: 150, height: 120, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item['itemName'], style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ).animate().fade(duration: 400.ms).scale(),
    );
  }
}
