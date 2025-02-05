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
        automaticallyImplyLeading: true, // This adds the default back button (left-side arrow)
        backgroundColor: Colors.lightBlue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.restaurant_menu, // Icon for visual appeal
              size: 50,
              color: Colors.lightBlue,
            ),
            SizedBox(height: 20),
            Text(
              'Add a New Menu Item',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _itemNameController,
              decoration: InputDecoration(
                labelText: 'Item Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.fastfood),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _dayController,
              decoration: InputDecoration(
                labelText: 'Day',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.monetization_on),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 15),
            TextField(
              controller: _imagePathController,
              decoration: InputDecoration(
                labelText: 'Image Path',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.image),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _addMenuItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text('Add Item'),
            ),
          ],
        ),
      ),
    );
  }
}
