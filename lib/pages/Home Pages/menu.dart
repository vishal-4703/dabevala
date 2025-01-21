import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _menuItems = [];
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('MenuItems');
  final DatabaseReference _cartItemsRef = FirebaseDatabase.instance.ref().child('CartItems');

  @override
  void initState() {
    super.initState();
    // Listen to changes in the 'MenuItems' node in the database
    _database.onValue.listen((event) {
      List<Map<String, dynamic>> newMenuItems = [];
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null) {
        Map<dynamic, dynamic> values = Map<dynamic, dynamic>.from(dataSnapshot.value as Map);
        values.forEach((key, value) {
          newMenuItems.add({
            'key': key as String,
            'itemName': value['itemName'] as String? ?? 'Default Item Name',
            'day': value['day'] as String? ?? 'Unknown Day',
            'price': value['price'] as String? ?? '0',
            'assetImagePath': value['assetImagePath'] as String? ?? 'assets/default_image.png'
          });
        });
      }
      setState(() {
        _menuItems = newMenuItems.cast<Map<String, dynamic>>();
      });
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addToCart(Map<String, dynamic> item) {
    String key = _cartItemsRef.push().key ?? 'default_key'; // Generate a unique key for the new item
    Map<String, dynamic> newCartItem = {
      'name': item['itemName'],
      'price': double.parse(item['price']),
      'description': item['day'],
      'quantity': 1, // Default quantity set to 1
    };
    _cartItemsRef.child(key).set(newCartItem).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item added to cart')));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add item to cart')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushNamed(context, 'FoodGoHomePage');
          },
        ),
        title: Text('Our Menu'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, 'card'); // Specify the route to the cart screen
            },
          ),
          SizedBox(width: 15),
        ],
      ),
      body: SingleChildScrollView(
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
                    onAddToCart: () {
                      _addToCart(item);
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      // onPressed: () {
      // Navigator.pushNamed(context, 'AddMenuItemPage');
      //},
      // child: Icon(Icons.add),
      // ),
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
  final VoidCallback onAddToCart;

  MenuItem({required this.title, required this.day, required this.price, required this.imagePath, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 150, // Adjust width as needed
        height: 300, // Adjust height as needed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(imagePath, fit: BoxFit.cover, height: 70), // Adjust height as needed
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), // Adjust font size as needed
                  Text('Day: $day', style: TextStyle(fontSize: 12)), // Adjust font size as needed
                  Text('Price: ₹$price', style: TextStyle(fontSize: 12)), // Adjust font size as needed
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart, size: 20), // Adjust icon size as needed
              onPressed: onAddToCart,
            ),
          ],
        ),
      ),
    );
  }
}
