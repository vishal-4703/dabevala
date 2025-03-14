import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import 'cart_page.dart';
import 'profile.dart';
import 'profiles pages/NextPage.dart';
import 'subscription.dart';



class FoodGoHomePage extends StatefulWidget {
  @override
  _FoodGoHomePageState createState() => _FoodGoHomePageState();
}

class _FoodGoHomePageState extends State<FoodGoHomePage> {
  int _selectedIndex = 0;
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('MenuItems');
  PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  List<Map<String, dynamic>> _todaysOffer = [];
  List<Map<String, dynamic>> _offers = [];
  List<Map<String, dynamic>> _popular = [];
  List<Map<String, dynamic>> _filteredTodaysOffer = [];
  List<Map<String, dynamic>> _filteredOffers = [];
  List<Map<String, dynamic>> _filteredPopular = [];

  @override
  void initState() {
    super.initState();
    _fetchMenuItems();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage < _filteredTodaysOffer.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _fetchMenuItems() {
    _database.onValue.listen((event) {
      List<Map<String, dynamic>> todaysOffer = [];
      List<Map<String, dynamic>> offers = [];
      List<Map<String, dynamic>> popular = [];

      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null) {
        Map<dynamic, dynamic> values = Map<dynamic, dynamic>.from(dataSnapshot.value as Map);
        values.forEach((key, value) {
          Map<String, dynamic> menuItem = {
            'id': key,
            'itemName': value['itemName'] ?? 'Default Item',
            'category': value['category']?.toString().toLowerCase() ?? '',
            'price': value['price'] ?? '0',
            'day': value['day'] ?? 'N/A',
            'discount': value['discount'] ?? 'No Discount',
            'assetImagePath': value['assetImagePath'] ?? 'assets/default_image.png'
          };
          if (menuItem['category'] == 'todays offer') {
            todaysOffer.add(menuItem);
          } else if (menuItem['category'] == 'offers') {
            offers.add(menuItem);
          } else if (menuItem['category'] == 'popular') {
            popular.add(menuItem);
          }
        });
      }
      setState(() {
        _todaysOffer = todaysOffer;
        _offers = offers;
        _popular = popular;
        _filteredTodaysOffer = todaysOffer;
        _filteredOffers = offers;
        _filteredPopular = popular;
      });
    });
  }

  void _performSearch(String query) {
    setState(() {
      _filteredTodaysOffer = _todaysOffer
          .where((item) => item['itemName'].toLowerCase().contains(query.toLowerCase()))
          .toList();
      _filteredOffers = _offers
          .where((item) => item['itemName'].toLowerCase().contains(query.toLowerCase()))
          .toList();
      _filteredPopular = _popular
          .where((item) => item['itemName'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  List<Widget> get _pages => [
    HomeContent(
      todaysOffer: _filteredTodaysOffer,
      offers: _filteredOffers,
      popular: _filteredPopular,
      pageController: _pageController,
      currentPage: _currentPage,
      onSearch: _performSearch,
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
    ),
    sub(),
    CartPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text('DABBAWALA', style: TextStyle(fontSize: 20,color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.teal.shade700,
        elevation: 4,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'ProfilePage');
            },
            child: Padding(
              padding: EdgeInsets.only(right: 16),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/profile.jpg'),
                radius: 22,
              ),
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex].animate().fade(duration: 600.ms).slideY(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, 'MenuPage'),
        child: Icon(Icons.fastfood, color: Colors.amberAccent),
        backgroundColor: Colors.teal.shade700,
        elevation: 6,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      buttonBackgroundColor: Colors.teal.shade700,
      color: Colors.teal.shade700,
      height: 60,
      animationDuration: Duration(milliseconds: 400),
      items: <Widget>[
        Icon(Icons.home, size: 30, color: Colors.white),
        Icon(Icons.card_membership, size: 30, color: Colors.white),
        Icon(Icons.shopping_cart, size: 30, color: Colors.white),
        Icon(Icons.person, size: 30, color: Colors.white),
      ],
      onTap: _onItemTapped,
    );
  }
}

// Home Page Content
class HomeContent extends StatelessWidget {
  final List<Map<String, dynamic>> todaysOffer;
  final List<Map<String, dynamic>> offers;
  final List<Map<String, dynamic>> popular;
  final PageController pageController;
  final int currentPage;
  final Function(String) onSearch;
  final Function(int) onPageChanged;

  HomeContent({
    required this.todaysOffer,
    required this.offers,
    required this.popular,
    required this.pageController,
    required this.currentPage,
    required this.onSearch,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text('Hey!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))
                .animate().fade().scale(duration: 500.ms),
            SizedBox(height: 5),
            Text('Let\'s get your order', style: TextStyle(color: Colors.grey, fontSize: 16))
                .animate().fade(duration: 400.ms),
            SizedBox(height: 15),

            // Search Bar
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search our delicious Food',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              ),
              onSubmitted: onSearch,
            ).animate().fade(duration: 600.ms),

            SizedBox(),
            _buildCategoryList(context, '', todaysOffer, isHorizontal: true),
            SizedBox(height: 20),
            _buildCategoryList(context, '🎉 Special Offers', offers, isHorizontal: true),
            SizedBox(height: 20),
            _buildCategoryList(context, '🍽️ Popular Dishes', popular),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context, String title, List<Map<String, dynamic>> items, {bool isHorizontal = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
            .animate().fade(duration: 500.ms),
        SizedBox(height: 10),
        if (isHorizontal && title == '🎉 Special Offers')
          Container(
            height: 150, // Fixed height for horizontal scroll
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _buildHorizontalSmallFoodCard(items[index], context);
              },
            ),
          ),
        if (isHorizontal && title != '🎉 Special Offers')
          Column(
            children: [
              Container(
                height: 290, // Increased height for Today's Offer
                child: PageView.builder(
                  controller: pageController,
                  itemCount: items.length,
                  onPageChanged: onPageChanged, // Update current page index
                  itemBuilder: (context, index) {
                    return _buildHorizontalFoodCard(items[index], context);
                  },
                ),
              ),
              SizedBox(height: 10),
              // Fixed Page Indicators
              Container(
                width: double.infinity,
                child: Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: List.generate(items.length, (index) {
                      return Container(
                        width: 8,
                        height: 8,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentPage == index ? Colors.teal.shade700 : Colors.grey,
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        if (!isHorizontal)
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _buildFoodCard(items[index], context);
            },
          ),
      ],
    );
  }

  Widget _buildHorizontalSmallFoodCard(Map<String, dynamic> item, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NextPage(
              itemName: item['itemName'],
              day: item['day'],
              price: item['price'],
              assetImagePath: item['assetImagePath'],
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Container(
            width: 170, // Adjust width for smaller cards
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    item['assetImagePath'],
                    width: double.infinity,
                    height: 80, // Adjust height for smaller cards
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['itemName'],
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Text(
                        '\₹${item['price']}',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ).animate().fade(duration: 400.ms).scale(),
      ),
    );
  }

  Widget _buildHorizontalFoodCard(Map<String, dynamic> item, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NextPage(
              itemName: item['itemName'],
              day: item['day'],
              price: item['price'],
              assetImagePath: item['assetImagePath'],
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade700, Colors.greenAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.asset(
                    item['assetImagePath'],
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['itemName'],
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Text(
                        '\₹${item['price']}',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Add to cart or navigate to details
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Order Now',
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ).animate().fade(duration: 400.ms).scale(),
      ),
    );
  }

  Widget _buildFoodCard(Map<String, dynamic> item, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NextPage(
              itemName: item['itemName'],
              day: item['day'],
              price: item['price'],
              assetImagePath: item['assetImagePath'],
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                item['assetImagePath'],
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['itemName'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(
                    '\₹${item['price']}',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fade(duration: 400.ms).scale(),
    );
  }
}