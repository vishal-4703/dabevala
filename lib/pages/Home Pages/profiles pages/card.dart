import 'package:flutter/material.dart';
import 'cart_service.dart';
import 'package:firebase_database/firebase_database.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final CartService _cartService = CartService();
  double _totalPrice = 0.0;

  void _addItem() {
    try {
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      String name = 'Item ${id.substring(id.length - 4)}';
      double price = 10.0;
      String day = 'Monday';
      String imagePath = 'assets/images/sample.png';

      _cartService.addItemToCart(id, name, day, imagePath, price);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to add item: $e'),
      ));
    }
  }

  void _calculateTotalPrice(Map<String, dynamic> cartData) {
    double total = 0.0;
    cartData.forEach((key, value) {
      total += value['price'];
    });
    setState(() {
      _totalPrice = total;
    });
  }

  void _updateItem(String id, String newName, double newPrice, String newDay, String newImagePath) {
    try {
      _cartService.updateCartItem(id, newName, newPrice, newDay, newImagePath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update item: $e'),
      ));
    }
  }

  void _deleteItem(String id) {
    try {
      _cartService.deleteCartItem(id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete item: $e'),
      ));
    }
  }

  void _showEditDialog(String id, Map<String, dynamic> currentItem) {
    TextEditingController nameController = TextEditingController(text: currentItem['itemName']);
    TextEditingController priceController = TextEditingController(text: currentItem['price'].toString());
    TextEditingController dayController = TextEditingController(text: currentItem['day']);
    TextEditingController imagePathController = TextEditingController(text: currentItem['assetImagePath']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: dayController,
                decoration: InputDecoration(labelText: 'Day'),
              ),
              TextField(
                controller: imagePathController,
                decoration: InputDecoration(labelText: 'Image Path'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _updateItem(
                  id,
                  nameController.text,
                  double.parse(priceController.text),
                  dayController.text,
                  imagePathController.text,
                );
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Page'),
      ),
      body: Column(
        children: [
          StreamBuilder<DatabaseEvent>(
            stream: _cartService.cartStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic>? data = (snapshot.data!.snapshot.value as Map?)?.cast<String, dynamic>();

                if (data == null) {
                  return Center(child: Text('No items in the cart'));
                }

                _calculateTotalPrice(data);

                return Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        String key = data.keys.elementAt(index);
                        Map<String, dynamic> item = Map<String, dynamic>.from(data[key]);
                        return ListTile(
                          title: Text(item['itemName']),
                          subtitle: Text('Price: ${item['price']} - Day: ${item['day']}'),
                          leading: Image.asset(item['assetImagePath']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => _showEditDialog(key, item),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteItem(key),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Text('Total Price: ₹$_totalPrice'),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _addItem,
                      child: Text('Add Item'),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error loading data'));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
