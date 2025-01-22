import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _menuItems = [];
  List<Map<String, dynamic>> _cartItems = [];
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('MenuItems');

  @override
  void initState() {
    super.initState();
    _database.onValue.listen((event) {
      List<Map<String, dynamic>> newMenuItems = [];
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null) {
        Map<dynamic, dynamic> values = Map<dynamic, dynamic>.from(dataSnapshot.value as Map);
        values.forEach((key, value) {
          newMenuItems.add({
            'id': key as String,
            'itemName': value['itemName'] as String? ?? 'Default Item Name',
            'day': value['day'] as String? ?? 'Unknown Day',
            'price': value['price'] as String? ?? '0',
            'assetImagePath': value['assetImagePath'] as String? ?? 'assets/default_image.png'
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

  void _removeFromCart(Map<String, dynamic> item) {
    setState(() {
      _cartItems.removeWhere((cartItem) => cartItem['id'] == item['id']);
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(
                    cartItems: _cartItems,
                    onRemoveFromCart: _removeFromCart,
                    databaseReference: FirebaseDatabase.instance.ref().child('CartItems'), // Pass the database reference
                  ),
                ),
              );
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
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 200,
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(10),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: _menuItems.map((item) {
                  return MenuItem(
                    id: item['id'],
                    title: item['itemName'],
                    day: item['day'],
                    price: item['price'],
                    imagePath: item['assetImagePath'],
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NextPage(
                            itemName: item['itemName'],
                            day: item['day'],
                            price: item['price'],
                            imagePath: item['assetImagePath'],
                            onAddToCart: (newCartItem) {
                              setState(() {
                                _cartItems.add(newCartItem);
                              });
                            },
                            cartItems: _cartItems,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
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
  final String id;
  final String title;
  final String day;
  final String price;
  final String imagePath;
  final VoidCallback onPressed;

  MenuItem({
    required this.id,
    required this.title,
    required this.day,
    required this.price,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 150,
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(imagePath, fit: BoxFit.cover, height: 70),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  Text('Day: $day', style: TextStyle(fontSize: 12)),
                  Text('Price: ₹$price', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward, size: 20),
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  final String itemName;
  final String day;
  final String price;
  final String imagePath;
  final Function(Map<String, dynamic>) onAddToCart;
  final List<Map<String, dynamic>> cartItems;

  NextPage({
    required this.itemName,
    required this.day,
    required this.price,
    required this.imagePath,
    required this.onAddToCart,
    required this.cartItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF000000)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Color(0xFF000000)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(
                    cartItems: cartItems,
                    onRemoveFromCart: (item) {}, // Placeholder
                    databaseReference: FirebaseDatabase.instance.ref().child('CartItems'), // Pass the database reference
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 4,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          imagePath,
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      itemName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Icon(Icons.star, color: Color(0xFFF2C94C));
                      }),
                    ),
                    SizedBox(height: 10),
                    Text(
                      day,
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(0xFF000000),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '₹ $price',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(0xFF0223FA),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Full INDIAN Dish',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF828282),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                final newCartItem = {
                  'id': DateTime.now().toString(), // Unique ID for the cart item
                  'name': itemName,
                  'price': price,
                  'day': day,
                  'imagePath': imagePath,
                  'description': 'Full INDIAN Dish',
                };

                onAddToCart(newCartItem);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added to cart!'),
                  ),
                );

                // Navigate to CartPage after adding to cart
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(
                      cartItems: cartItems,
                      onRemoveFromCart: (item) {}, // Placeholder
                      databaseReference: FirebaseDatabase.instance.ref().child('CartItems'), // Pass the database reference
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0333F4),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Add To Cart',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(Map<String, dynamic>) onRemoveFromCart;
  final DatabaseReference databaseReference; // Add this

  CartPage({
    required this.cartItems,
    required this.onRemoveFromCart,
    required this.databaseReference, // Add this
  });

  double calculateTotal() {
    double total = 0.0;
    for (var item in cartItems) {
      total += double.tryParse(item['price']) ?? 0.0; // Ensure price is parsed as double
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = calculateTotal();

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: Image.asset(item['imagePath'], width: 50, height: 50),
                  title: Text(item['name']),
                  subtitle: Text('Day: ${item['day']}\nPrice: ₹${item['price']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Call the function to remove the item from the cart
                      onRemoveFromCart(item);
                      // Call the function to delete the item from the database
                      deleteItemFromDatabase(item['id']);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total: ₹$totalAmount',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'payment'); // Navigate to Payment Page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0333F4),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Pay Now',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void deleteItemFromDatabase(String itemId) {
    // Assuming you have a reference to the database
    databaseReference.child(itemId).remove().then((_) {
      print("Item deleted successfully.");
    }).catchError((error) {
      print("Failed to delete item: $error");
    });
  }
}

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Center(
        child: Text(
          'Payment processing will be implemented here.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}