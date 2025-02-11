import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class OrderListScreen extends StatefulWidget {
  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  final DatabaseReference databaseReference =
  FirebaseDatabase.instance.ref().child('cartItems');

  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    try {
      databaseReference.onValue.listen((event) {
        if (event.snapshot.value == null) {
          setState(() {
            cartItems.clear();
            isLoading = false;
          });
          return;
        }

        List<Map<String, dynamic>> fetchedCartItems = [];
        Map<dynamic, dynamic> values =
        Map<dynamic, dynamic>.from(event.snapshot.value as Map);

        values.forEach((key, value) {
          fetchedCartItems.add({
            'id': key,
            'name': value['name'] ?? 'Unknown',
            'price': value['price'] ?? '0',
            'day': value['day'] ?? 'Unknown',
            'image': value['image'] ?? '', // Store image path or URL
            'description': value['description'] ?? 'No description available',
          });
        });

        setState(() {
          cartItems = fetchedCartItems;
          isLoading = false;
        });
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load cart items.";
        isLoading = false;
      });
    }
  }

  double calculateTotal() {
    return cartItems.fold(
        0.0, (total, item) => total + (double.tryParse(item['price'].toString()) ?? 0.0));
  }

  void _removeFromCart(Map<String, dynamic> item) {
    setState(() {
      cartItems.remove(item);
    });
    deleteItemFromDatabase(item['id']);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item['name']} removed from cart')),
    );
  }

  void deleteItemFromDatabase(String itemId) {
    databaseReference.child(itemId).remove().then((_) {
      print("Item deleted successfully.");
    }).catchError((error) {
      print("Failed to delete item: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF5ACFF4),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
        child: Text(
          errorMessage!,
          style: TextStyle(color: Colors.red, fontSize: 18),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    leading: item['image'] != null && item['image'].isNotEmpty
                        ? (item['image'].startsWith('assets/')
                        ? Image.asset(
                      item['image'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    )
                        : Image.network(
                      item['image'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.broken_image, size: 60, color: Colors.grey);
                      },
                    ))
                        : Icon(Icons.image, size: 60, color: Colors.grey),
                    title: Text(
                      item['name'],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text(
                      'Day: ${item['day']}\nPrice: ₹${item['price']}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeFromCart(item),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total: ₹${calculateTotal().toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0333F4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
