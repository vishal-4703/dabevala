import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddMenuItemPage extends StatefulWidget {
  @override
  _AddMenuItemPageState createState() => _AddMenuItemPageState();
}

class _AddMenuItemPageState extends State<AddMenuItemPage> {
  final _itemNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imagePathController = TextEditingController(text: 'assets/');

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child("MenuItems");

  String _selectedCategory = "meals"; // Default category
  String _selectedDay = "Monday"; // Default day

  // List of days for the dropdown
  final List<String> _daysOfWeek = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
    "All Day's",
  ];

  void _addMenuItem() {
    final String itemName = _itemNameController.text.trim();
    final String price = _priceController.text.trim();
    final String imagePath = _imagePathController.text.trim();

    if (itemName.isEmpty || price.isEmpty || _selectedCategory.isEmpty || _selectedDay.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⚠️ All fields are required!')),
      );
      return;
    }

    _dbRef.push().set({
      "itemName": itemName,
      "day": _selectedDay,
      "price": price,
      "assetImagePath": imagePath,
      "category": _selectedCategory,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Menu Item Added Successfully!')),
      );
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Failed to add item: $error')),
      );
    });

    print("✔ Added Item: $itemName | Day: $_selectedDay | Price: ₹$price | Category: $_selectedCategory");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Menu Item'),
        backgroundColor: Colors.teal.shade700,
        elevation: 3,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.restaurant_menu, size: 50, color: Colors.teal.shade700),
            SizedBox(height: 20),
            Text(
              'Add a New Menu Item',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal.shade700),
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
            DropdownButtonFormField<String>(
              value: _selectedDay,
              decoration: InputDecoration(
                labelText: "Select Day",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              items: _daysOfWeek.map((String day) {
                return DropdownMenuItem<String>(
                  value: day,
                  child: Text(day),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDay = value!;
                });
              },
            ),
            SizedBox(height: 15),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Price (₹)',
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
            SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: "Select Category",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: [
                DropdownMenuItem(value: "meals", child: Text("Meals")),
                DropdownMenuItem(value: "7days", child: Text("7 Days Meals")),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _addMenuItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text('➕ Add Item', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}