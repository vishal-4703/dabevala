import 'package:flutter/material.dart';






class FoodGoHomePage extends StatelessWidget {
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
              radius: 40, // Adjusted radius for better fit
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
              Text(
                'A-143, Coba, Mumbai',
                style: TextStyle(color: Colors.grey),
              ),
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    OfferCard(
                      discount: '10% OFF',
                      description: 'Avail best discounts on your first order',
                      color: Colors.lightBlueAccent,
                      imageUrl: 'assets/indian2.jpeg',
                      onPressed: () {
                        Navigator.pushNamed(context, 'first');

                      },
                    ),
                    SizedBox(width: 10),
                    OfferCard(
                      discount: '15% OFF',
                      description: 'Delicious meal discounts',
                      color: Colors.pinkAccent.shade100,
                      imageUrl: 'assets/indian6.jpeg',
                      onPressed: () {
                        Navigator.pushNamed(context, 'second');
                      },
                    ),
                    SizedBox(width: 10),
                    OfferCard(
                      discount: '20% OFF',
                      description: 'Exclusive weekend offers',
                      color: Colors.amberAccent,
                      imageUrl: 'assets/indian3.jpeg',
                      onPressed: () {
                        Navigator.pushNamed(context, 'third');
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CategoryButton(label: 'Veg', onSelected: (_) {
                    Navigator.pushNamed(context, 'vegfoodpage');
                  }),
                  CategoryButton(label: "Non Veg", onSelected: (_) {
                    Navigator.pushNamed(context, 'nonveg');
                  }),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
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
              icon: Icon(Icons.home, color: Colors.blue, size: 30),
              onPressed: () {
                Navigator.pushNamed(context, 'FoodGoHomePage');
              },
            ),
            IconButton(
              icon: Icon(Icons.fastfood, color: Colors.grey, size: 30),
              onPressed: () {
                Navigator.pushNamed(context, 'MenuPage');
              },
            ),
            SizedBox(width: 30),
            IconButton(
              icon: Icon(Icons.card_membership, color: Colors.grey, size: 30),
              onPressed: () {
                Navigator.pushNamed(context, 'sub');
              },
            ),
            IconButton(
              icon: Icon(Icons.person, color: Colors.grey, size: 30),
              onPressed: () {
                Navigator.pushNamed(context, 'ProfilePage');
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
            Image.asset(imageUrl, height: 150, width: 200, fit: BoxFit.cover),
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
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 6)],
        ),
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(imageUrl, height: 80, width: double.infinity, fit: BoxFit.cover),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(description, style: TextStyle(color: Colors.grey)),
            Spacer(),
            Row(
              children: [
                Icon(Icons.star, color: Colors.orange, size: 16),
                SizedBox(width: 5),
                Text(rating.toString()),
              ],
            ),
          ],
        ),
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
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 6)],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(imageUrl, height: 80, width: 80, fit: BoxFit.cover),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text(description, style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 16),
                      SizedBox(width: 5),
                      Text(rating.toString()),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: tags
                        .map((tag) => Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Chip(label: Text(tag)),
                    ))
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
