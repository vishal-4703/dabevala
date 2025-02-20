import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../pages/Home Pages/profiles pages/logout.dart';
import 'addmenu.dart';
import 'dabbawala_list_screen.dart';
import 'customer_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    CustomerListScreen(),
    Menu(),
    DabbawalaListScreen(),
    logout(),
  ];

  void _onItemTapped(int index) {
    if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => logout()),
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
        title: Text('Dabbawala Admin Dashboard',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: 30)),

        backgroundColor: Colors.teal.shade700,
        centerTitle: true,
        elevation: 4,
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
        ),
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.teal.shade700,
        buttonBackgroundColor: Colors.teal.shade700,
        height: 60,
        items: <Widget>[
          Icon(Icons.people, size: 30, color: Colors.white),
          Icon(Icons.restaurant_menu, size: 30, color: Colors.white),
          Icon(Icons.list, size: 30, color: Colors.white),
          Icon(Icons.logout, size: 30, color: Colors.redAccent),
        ],
        index: _selectedIndex,
        onTap: _onItemTapped,
        animationDuration: Duration(milliseconds: 300),
      ),
    );
  }
}


