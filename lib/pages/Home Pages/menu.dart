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
  bool _isLoading = true;

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
        _isLoading = false;
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
                  ),
                ),
              );
            },
          ),
          SizedBox(width: 15),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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

  final DatabaseReference cartRef = FirebaseDatabase.instance.ref().child('UserCart'); // Reference to User Cart

  void addCartItemToDatabase(Map<String, dynamic> cartItem) {
    cartRef.push().set(cartItem).then((_) {
      print("Cart item added successfully.");
    }).catchError((error) {
      print("Failed to add cart item: $error");
    });
  }

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
                    onRemoveFromCart: (item) {},
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
                        color: Color(0xFF0223C3),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Map<String, dynamic> newCartItem = {
                          'name': itemName,
                          'price': price,
                          'day': day,
                          'imagePath': imagePath,
                          'description': 'Delicious meal',
                        };

                        onAddToCart(newCartItem); // Update cartItems locally
                        addCartItemToDatabase(newCartItem); // Save to Firebase
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(fontSize: 18),
                      ),
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
}

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(Map<String, dynamic>) onRemoveFromCart;

  CartPage({
    required this.cartItems,
    required this.onRemoveFromCart,
  });

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late DatabaseReference _cartRef;
  List<Map<String, dynamic>> _firebaseCartItems = [];
  double _totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _cartRef = FirebaseDatabase.instance.ref().child('UserCart');
    _loadCartItems();
  }

  void _loadCartItems() {
    _cartRef.onValue.listen((event) {
      final dataSnapshot = event.snapshot;
      List<Map<String, dynamic>> loadedCartItems = [];

      if (dataSnapshot.value != null) {
        Map<dynamic, dynamic> values = Map<dynamic, dynamic>.from(dataSnapshot.value as Map);
        values.forEach((key, value) {
          loadedCartItems.add({
            'id': key,
            'name': value['name'],
            'price': value['price'],
            'day': value['day'],
            'imagePath': value['imagePath'],
            'description': value['description'],
          });
        });

        setState(() {
          _firebaseCartItems = loadedCartItems;
          _totalAmount = _calculateTotal(_firebaseCartItems);
        });
      }
    });
  }

  double _calculateTotal(List<Map<String, dynamic>> cartItems) {
    return cartItems.fold(0.0, (total, item) {
      double itemPrice = double.tryParse(item['price']) ?? 0.0;
      return total + itemPrice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _firebaseCartItems.isEmpty
                ? Center(child: Text('No items in cart'))
                : ListView.builder(
              itemCount: _firebaseCartItems.length,
              itemBuilder: (context, index) {
                final item = _firebaseCartItems[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.asset(item['imagePath'], width: 70, height: 70),
                    title: Text(item['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    subtitle: Text('Day: ${item['day']}\nPrice: ₹${item['price']}', style: TextStyle(fontSize: 14)),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _removeFromCart(item['id']);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total: ₹$_totalAmount',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'payment');
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



  void _removeFromCart(String cartItemId) {
    setState(() {
      _firebaseCartItems.removeWhere((item) => item['id'] == cartItemId);
    });

    _cartRef.child(cartItemId).remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item removed from cart')),
      );
    }).catchError((error) {
      print("Failed to remove item: $error");
    });
  }
}

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: Center(
        child: Text('Payment Page', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
