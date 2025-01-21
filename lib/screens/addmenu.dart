import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _selectedIndex = 0;
  List<Map<dynamic, dynamic>> _menuItems = [];
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('MenuItems');

  @override
  void initState() {
    super.initState();
    // Listen to changes in the 'MenuItems' node in the database
    _database.onValue.listen((event) {
      List<Map<dynamic, dynamic>> newMenuItems = [];
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null) {
        Map<dynamic, dynamic> values = Map<dynamic, dynamic>.from(dataSnapshot.value as Map);
        values.forEach((key, value) {
          newMenuItems.add({
            'key': key,
            'itemName': value['itemName'] ?? 'Default Item Name',
            'day': value['day'] ?? 'Unknown Day',
            'price': value['price'] ?? '0',
            'assetImagePath': value['assetImagePath'] ?? 'assets/default_image.png'
          });
        });
      }
      setState(() {
        _menuItems = newMenuItems;
      });
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addMenuItem(String itemName, String day, String price, String imagePath) {
    String key = _database.push().key ?? 'default_key'; // Generate a unique key for the new item
    Map<String, dynamic> newItem = {
      'itemName': itemName,
      'day': day,
      'price': price,
      'assetImagePath': imagePath
    };
    _database.child(key).set(newItem).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item added successfully')));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add item')));
    });
  }

  void _updateMenuItem(String key, String itemName, String day, String price, String imagePath) {
    Map<String, dynamic> updatedItem = {
      'itemName': itemName,
      'day': day,
      'price': price,
      'assetImagePath': imagePath
    };
    _database.child(key).update(updatedItem).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item updated successfully')));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update item')));
    });
  }

  void _deleteMenuItem(String key) {
    _database.child(key).remove().then((_) {
      setState(() {
        _menuItems.removeWhere((item) => item['key'] == key);  // Update local list
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item deleted successfully')));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete item')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushNamed(context, 'DashboardScreen');
          },
        ),
        title: Text('Our Menu'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, 'ShoppingCartScreen'); // Specify the route
            },
          ),
          SizedBox(width: 15),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TabItem(
                      title: 'Meals',
                      isActive: _selectedIndex == 0,
                      onPressed: () {
                        _onTabSelected(0);
                      },
                    ),
                    // Add more TabItems here if necessary
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 200, // Adjust this value as needed
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: EdgeInsets.all(10),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: _menuItems.map((item) {
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
                ),
              ),
            ],
          ),
        ),
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

class TabItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onPressed;

  TabItem({required this.title, required this.isActive, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isActive ? Colors.orange : Colors.black,
            ),
          ),
          if (isActive)
            Container(
              margin: EdgeInsets.only(top: 5),
              height: 2,
              width: 20,
              color: Colors.orange,
            ),
        ],
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
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(imagePath, fit: BoxFit.cover),
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
      ),
    );
  }
}
