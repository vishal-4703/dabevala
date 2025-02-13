import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:carousel_slider/carousel_slider.dart';

class FoodGoHomePage extends StatelessWidget {
  final DatabaseReference _foodRef = FirebaseDatabase.instance.ref('cartiteam');  // Firebase reference

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DABBAWALA'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, 'ProfilePage');
            },
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/profile.jpg'),
              radius: 40,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(),
              SizedBox(height: 25),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search for dishes, tiffin providers...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Today's Offers",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              buildCarouselSlider(context),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 10, height: 120),
                  Expanded(
                    flex: 2,
                    child: CategoryButton(
                      label: "Non Veg",
                      onSelected: (_) {
                        Navigator.pushNamed(context, 'nonveg');
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1),
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
              SizedBox(height: 20),
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
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: Colors.blue, size: 40),
              onPressed: () {
                Navigator.pushNamed(context, 'FoodGoHomePage');
              },
            ),
            IconButton(
              icon: Icon(Icons.fastfood, color: Colors.grey, size: 40),
              onPressed: () {
                Navigator.pushNamed(context, 'MenuPage');
              },
            ),
            SizedBox(width: 30),
            IconButton(
              icon: Icon(Icons.card_membership, color: Colors.grey, size: 40),
              onPressed: () {
                Navigator.pushNamed(context, 'sub');
              },
            ),
            IconButton(
              icon: Icon(Icons.person, color: Colors.grey, size: 40),
              onPressed: () {
                Navigator.pushNamed(context, 'ProfilePage');
              },
            ),
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
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(10),
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

  Future<List<FoodItem>> getFoodItems() async {
    try {
      final snapshot = await _foodRef.get();
      final data = snapshot.value;

      // Ensure that the data is not null and is of the type Map
      if (data != null && data is Map<dynamic, dynamic>) {
        List<FoodItem> foodItems = [];
        Map<dynamic, dynamic> mapData = Map<dynamic, dynamic>.from(data);

        // Iterate through the map and add FoodItem objects to the list
        mapData.forEach((key, value) {
          foodItems.add(FoodItem.fromMap(Map<String, dynamic>.from(value)));
        });

        return foodItems;
      }

      return [];
    } catch (e) {
      print('Error fetching food items: $e');
      return [];
    }
  }
}

class FoodItem {
  final String name;
  final String description;
  final double price;

  FoodItem({required this.name, required this.description, required this.price});

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      name: map['name'],
      description: map['description'],
      price: map['price'],
    );
  }
}

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
        width: 300, // Fixed width for uniformity
        height: 200, // Fixed height for uniformity
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

class CategoryButton extends StatelessWidget {
  final String label;
  final ValueChanged<void> onSelected;

  CategoryButton({required this.label, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onSelected(null),
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
