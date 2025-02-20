import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'profiles pages/NextPage.dart'; // Ensure correct import path

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _meals = [];
  List<Map<String, dynamic>> _sevenDaysMeals = [];
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('MenuItems');
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchMenuItems();
  }

  void _fetchMenuItems() {
    _database.onValue.listen((event) {
      List<Map<String, dynamic>> meals = [];
      List<Map<String, dynamic>> sevenDaysMeals = [];
      final dataSnapshot = event.snapshot;

      if (dataSnapshot.value != null) {
        Map<dynamic, dynamic> values = Map<dynamic, dynamic>.from(dataSnapshot.value as Map);
        values.forEach((key, value) {
          Map<String, dynamic> menuItem = {
            'id': key,
            'itemName': value['itemName'] ?? 'Default Item Name',
            'category': value['category']?.toString().toLowerCase() ?? 'meals',
            'day': value['day'] ?? 'Unknown Day',
            'price': value['price'] ?? '0',
            'assetImagePath': value['assetImagePath'] ?? 'assets/default_image.png'
          };

          // Categorizing meals correctly
          if (menuItem['category'] == 'meals') {
            meals.add(menuItem);
          } else if (menuItem['category'].contains('7days')) {
            sevenDaysMeals.add(menuItem);
          }
        });
      }

      setState(() {
        _meals = meals;
        _sevenDaysMeals = sevenDaysMeals;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Our Menu', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Meals"),
            Tab(text: "7 Days Meals"),
          ],
          indicatorColor: Colors.deepOrange,
          labelColor: Colors.white,
        ),
        backgroundColor: Colors.teal.shade700,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: [
          _buildMenuList(_meals),
          _buildMenuList(_sevenDaysMeals),
        ],
      ),
    );
  }

  Widget _buildMenuList(List<Map<String, dynamic>> menuItems) {
    return menuItems.isEmpty
        ? Center(
      child: Text(
        "No items found. Check Firebase categories!",
        style: TextStyle(color: Colors.red, fontSize: 16),
      ),
    )
        : GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return MenuItem(
          id: item['id'],
          title: item['itemName'],
          day: item['day'],
          price: item['price'],
          assetImagePath: item['assetImagePath'],
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NextPage(
                  itemName: item['itemName'],
                  day: item['day'],
                  price: item['price'],
                  assetImagePath: item['assetImagePath'],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// 🍽️ **MenuItem Widget**
class MenuItem extends StatelessWidget {
  final String id;
  final String title;
  final String day;
  final String price;
  final String assetImagePath;
  final VoidCallback onPressed;

  MenuItem({
    required this.id,
    required this.title,
    required this.day,
    required this.price,
    required this.assetImagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                assetImagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('Day: $day', style: TextStyle(fontSize: 14, color: Colors.grey)),
                Text('Price: ₹$price', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("View", style: TextStyle(color: Colors.white,fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
