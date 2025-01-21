import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddMenuItemPage extends StatefulWidget {
  @override
  _AddMenuItemPageState createState() => _AddMenuItemPageState();
}

class _AddMenuItemPageState extends State<AddMenuItemPage> {
  final _itemNameController = TextEditingController();
  final _dayController = TextEditingController();
  final _priceController = TextEditingController();
  final _imagePathController = TextEditingController(text: 'assets/');
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child("MenuItems");

  void _addMenuItem() {
    final String itemName = _itemNameController.text;
    final String day = _dayController.text;
    final String price = _priceController.text;
    final String imagePath = _imagePathController.text;

    if (itemName.isNotEmpty && day.isNotEmpty && price.isNotEmpty) {
      _dbRef.push().set({
        "itemName": itemName,
        "day": day,
        "price": price,
        "assetImagePath": imagePath,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Menu Item Added')));
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add item')));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('All fields are required')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Menu Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _itemNameController,
              decoration: InputDecoration(labelText: 'Item Name'),
            ),
            TextField(
              controller: _dayController,
              decoration: InputDecoration(labelText: 'Day'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: _imagePathController,
              decoration: InputDecoration(labelText: 'Image Path'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addMenuItem,
              child: Text('Add Item'),
            ),
          ],
        ),
      ),
    );
  }
}
