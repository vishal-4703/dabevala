import 'package:flutter/material.dart';
import 'package:your_project_name/pages/login%20pages/login.dart';
import '../pages/Home Pages/profiles pages/logout.dart';
import 'addmenu.dart';
import 'dabbawala_list_screen.dart';
import 'customer_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final List<Widget> _screens = [
    CustomerListScreen(),
    Menu(),
    DabbawalaListScreen(),
    Menu(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _onItemTapped(int index) {
    if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogoutPage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
      _animationController.forward().then((_) => _animationController.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dabbawala Admin Dashboard'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 4,
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: BottomNavigationBar(
                  backgroundColor: Colors.white,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.people, size: 28),
                      label: 'Customers',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.restaurant_menu, size: 28),
                      label: 'Food List',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.list, size: 28),
                      label: 'Dabbawala',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.logout, size: 28, color: Colors.redAccent),
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
                  elevation: 12,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logging Out'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You have been logged out.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => login()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text('Go to Login Page', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
