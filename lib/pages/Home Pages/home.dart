import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:your_project_name/pages/Home%20Pages/subscription.dart'; // Import the sub page
import 'profile.dart'; // Import the profile page
import 'cart_page.dart'; // Import the cart page

class FoodGoHomePage extends StatefulWidget {
  @override
  _FoodGoHomePageState createState() => _FoodGoHomePageState();
}

class _FoodGoHomePageState extends State<FoodGoHomePage> {
  int _selectedIndex = 0; // Track selected tab index

  // List of pages for navigation
  static final List<Widget> _pages = [
    HomeContent(),
    sub(), // Subscription page
    CartPage(), // Cart page
    ProfilePage(), // Profile page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back arrow
        title: Text(
          'DABBAWALA',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orangeAccent,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profile'); // Navigate to ProfilePage
            },
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/profile.jpg'),
              radius: 20,
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: _pages[_selectedIndex], // Display selected page
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'MenuPage');
        },
        child: Icon(Icons.fastfood, color: Colors.deepPurple),
        backgroundColor: Colors.orangeAccent,
        elevation: 5,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildAnimatedBottomNavigationBar(),
    );
  }

  // 🔹 Enhanced Bottom Navigation Bar with Animations
  Widget _buildAnimatedBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.white30],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.transparent,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 0, _selectedIndex, _onItemTapped),
            _buildNavItem(Icons.card_membership, 1, _selectedIndex, _onItemTapped),
            SizedBox(width: 40), // Space for FAB
            _buildNavItem(Icons.shopping_cart, 2, _selectedIndex, _onItemTapped),
            _buildNavItem(Icons.person, 3, _selectedIndex, _onItemTapped),
          ],
        ),
      ),
    );
  }

  // 🔹 Build Navigation Item with Animations
  Widget _buildNavItem(IconData icon, int index, int selectedIndex, Function(int) onItemTapped) {
    bool isSelected = selectedIndex == index;

    return InkWell(
      onTap: () => onItemTapped(index),
      splashColor: Colors.white.withOpacity(0.2), // Ripple effect
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.deepOrange : Colors.black.withOpacity(0.6),
              size: isSelected ? 30 : 24,
            ),
            if (isSelected)
              Container(
                margin: EdgeInsets.only(top: 4),
                height: 5,
                width: 5,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Home Content
class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(),
            SizedBox(height: 25),
            buildSearchBar(),
            SizedBox(height: 20),
            buildCarouselSlider(context),
            SizedBox(height: 20),
            buildPopularSection(context),
            SizedBox(height: 20),
            buildSpecialDishesSection(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to DABBAWALA!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          'Your favorite meals delivered to your door.',
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 15),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orangeAccent, Colors.deepOrange],
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(150),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Location: A-143, Colaba, Mumbai',
                style: TextStyle(color: Colors.white),
              ),
              Icon(Icons.location_on, color: Colors.white),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search for dishes, tiffin providers...',
        prefixIcon: Icon(Icons.search, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget buildCarouselSlider(BuildContext context) {
    final List<Map<String, dynamic>> offers = [
      {
        'discount': '10% OFF',
        'description': 'Avail best discounts on your first order',
        'color': Colors.lightBlueAccent,
        'imageUrl': 'assets/indian2.jpeg',
        'route': 'first',
      },
      {
        'discount': '15% OFF',
        'description': 'Delicious meal discounts',
        'color': Colors.pinkAccent.shade100,
        'imageUrl': 'assets/indian6.jpeg',
        'route': 'second',
      },
      {
        'discount': '20% OFF',
        'description': 'Exclusive weekend offers',
        'color': Colors.amberAccent,
        'imageUrl': 'assets/indian3.jpeg',
        'route': 'third',
      },
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
      ),
      items: offers.map((offer) {
        return Builder(
          builder: (BuildContext context) {
            return OfferCard(
              discount: offer['discount'],
              description: offer['description'],
              color: offer['color'],
              imageUrl: offer['imageUrl'],
              onPressed: () {
                Navigator.pushNamed(context, offer['route']);
              },
            );
          },
        );
      }).toList(),
    );
  }

  Widget buildPopularSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              PopularCard(
                title: 'Chicken Biryani',
                description: 'Delicious Biryani',
                rating: 4.8,
                imageUrl: 'assets/biryani.png',
                onPressed: () {
                  Navigator.pushNamed(context, 'biryani');
                },
              ),
              SizedBox(width: 10),
              PopularCard(
                title: 'Chicken',
                description: 'Tasty Chicken',
                rating: 4.3,
                imageUrl: 'assets/chicken.png',
                onPressed: () {
                  Navigator.pushNamed(context, 'chicken');
                },
              ),
              SizedBox(width: 10),
              PopularCard(
                title: 'SahiPanner',
                description: 'Creamy and delicious',
                rating: 4.5,
                imageUrl: 'assets/sahipanir.png',
                onPressed: () {
                  Navigator.pushNamed(context, 'sahipanner');
                },
              ),
              SizedBox(width: 10),
              PopularCard(
                title: 'Veg Noodle',
                description: 'Tasty lentil dish',
                rating: 4.2,
                imageUrl: 'assets/veg noodle.jpeg',
                onPressed: () {
                  Navigator.pushNamed(context, 'vegnoodle');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSpecialDishesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Special Dish',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        NearYouCard(
          title: 'Paneer',
          description: 'North Indian meals made using home-style recipes',
          rating: 4.2,
          tags: ['Veg', 'North Indian', 'Earth'],
          imageUrl: 'assets/panner.jpeg',
          onPressed: () {
            Navigator.pushNamed(context, 'panner');
          },
        ),
        SizedBox(height: 10),
        NearYouCard(
          title: 'Dal Masala',
          description: 'Explore the taste of South Indian Cuisines',
          rating: 3.8,
          tags: ['Veg', 'South Indian', 'Earth'],
          imageUrl: 'assets/dalmasala.png',
          onPressed: () {
            Navigator.pushNamed(context, 'dal');
          },
        ),
        SizedBox(height: 10),
        NearYouCard(
          title: 'SahiPanner',
          description: 'Explore the taste of South Indian Cuisines',
          rating: 3.8,
          tags: ['Veg', 'South Indian', 'Earth'],
          imageUrl: 'assets/sahipanir.png',
          onPressed: () {
            Navigator.pushNamed(context, 'sahipanner');
          },
        ),
      ],
    );
  }
}

// Define OfferCard widget
class OfferCard extends StatelessWidget {
  final String discount;
  final String description;
  final Color color;
  final String imageUrl;
  final VoidCallback onPressed;

  OfferCard({
    required this.discount,
    required this.description,
    required this.color,
    required this.imageUrl,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 300,
        height: 200,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              discount,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              description,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Image.asset(imageUrl, fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }
}

// Define CategoryButton widget
class CategoryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  CategoryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

// Define PopularCard widget
class PopularCard extends StatelessWidget {
  final String title;
  final String description;
  final double rating;
  final String imageUrl;
  final VoidCallback onPressed;

  PopularCard({
    required this.title,
    required this.description,
    required this.rating,
    required this.imageUrl,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Image.asset(imageUrl, height: 100, width: 100, fit: BoxFit.cover),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(description),
          Text('Rating: $rating'),
        ],
      ),
    );
  }
}

// Define NearYouCard widget
class NearYouCard extends StatelessWidget {
  final String title;
  final String description;
  final double rating;
  final List<String> tags;
  final String imageUrl;
  final VoidCallback onPressed;

  NearYouCard({
    required this.title,
    required this.description,
    required this.rating,
    required this.tags,
    required this.imageUrl,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        child: Row(
          children: [
            Image.asset(imageUrl, height: 100, width: 100),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text(description),
                  SizedBox(height: 5),
                  Row(
                    children: tags
                        .map((tag) => Chip(label: Text(tag)))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}