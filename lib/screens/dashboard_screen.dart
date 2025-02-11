import 'package:flutter/material.dart';
import 'package:your_project_name/pages/login%20pages/login.dart'; // Update the path
import 'addmenu.dart'; // Ensure this file exists
import 'dabbawala_list_screen.dart'; // Ensure this file exists
import 'order_list_screen.dart'; // Ensure this file exists
import 'customer_list_screen.dart'; // Ensure this file exists

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    DabbawalaListScreen(),
    OrderListScreen(),
    CustomerListScreen(),
    Menu(),
  ];

  void _onItemTapped(int index) {
    if (index == 4) {
      // Logout action
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => login()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dabbawala Admin Dashboard'),
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: false, // Removes the back button
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Dabbawala',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Customers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Food List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout, color: Colors.redAccent),
            label: 'Logout',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}
