import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  List<Map<dynamic, dynamic>> _menuItems = [];
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('MenuItems');
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    // Fetch menu items from Firebase
    _database.onValue.listen((event) {
      List<Map<dynamic, dynamic>> newMenuItems = [];
      final dataSnapshot = event.snapshot;

      if (dataSnapshot.value != null) {
        Map<dynamic, dynamic> values = Map<dynamic, dynamic>.from(dataSnapshot.value as Map);
        values.forEach((key, value) {
          print("Fetched Item: $value"); // Debug Print
          newMenuItems.add({
            'key': key,
            'itemName': value['itemName'] ?? 'Default Item',
            'day': value['day'] ?? 'Unknown',
            'price': value['price'] ?? '0',
            'assetImagePath': value['assetImagePath'] ?? 'assets/default_image.png',
            'category': value['category'] ?? 'meals' // Default category
          });
        });
      } else {
        print("No data found in Firebase!");
      }

      setState(() {
        _menuItems = newMenuItems;
      });
    });
  }

  void _deleteMenuItem(String key) {
    _database.child(key).remove().then((_) {
      setState(() {
        _menuItems.removeWhere((item) => item['key'] == key);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item deleted')));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete item')));
    });
  }

  Widget buildMenuGrid(String category) {
    List<Map<dynamic, dynamic>> filteredItems =
    _menuItems.where((item) => item['category'] == category).toList();

    print("Displaying ${filteredItems.length} items for category: $category"); // Debug Print

    if (filteredItems.isEmpty) {
      return Center(child: Text("No items found for $category"));
    }

    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(10),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: filteredItems.map((item) {
        return MenuItem(
          title: item['itemName'],
          day: item['day'],
          price: item['price'],
          imagePath: item['assetImagePath'],
          onDelete: () {
            _deleteMenuItem(item['key']);
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Our Menu',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Colors.teal.shade700,
        automaticallyImplyLeading: false, // This line removes the back arrow
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.orange,
          tabs: [
            Tab(text: 'Meals'),
            Tab(text: '7 Days Meals'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildMenuGrid("meals"),
          buildMenuGrid("7days"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'AddMenuItemPage');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String title;
  final String day;
  final String price;
  final String imagePath;
  final VoidCallback onDelete;

  MenuItem({required this.title, required this.day, required this.price, required this.imagePath, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: imagePath.startsWith("http")
                ? Image.network(imagePath, fit: BoxFit.cover)
                : Image.asset(imagePath, fit: BoxFit.cover),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Day: $day', style: TextStyle(fontSize: 12)),
                SizedBox(height: 4),
                Text('Price: ₹$price', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete, size: 20),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
