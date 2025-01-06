import 'package:flutter/material.dart';

class nonveg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pushNamed(context, 'FoodGoHomePage');
                  },
                ),
                Expanded(
                  child: Container(

                  ),
                )],
            ),
            SizedBox(height: 16),
            // Offer Banner
            Stack(
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: AssetImage('assets/chicken full.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [Colors.purpleAccent.withOpacity(0.75), Colors.blue.withOpacity(0.75)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    '50% OFF',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Biryani Offers
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NON VEG FOOD',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '70 Offers',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Row(
                    children: [
                      Text(
                        '#Non-Veg',
                        style: TextStyle(color: Colors.blue),
                      ),
                      SizedBox(width: 16),
                      Text(
                        '#Veg',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Veg Items
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  vegItem(
                    name: 'ButterChicken',
                    price: '₹ 60',
                    rating: 4.1,
                    imageUrl: 'assets/butterchicken.png',
                    onSelected: () {
                      Navigator.pushNamed(context, '');
                      print('Allo selected');
                    },
                  ),
                  vegItem(
                    name: 'Fried Fish',
                    price: '₹ 120',
                    rating: 3.7,
                    imageUrl: 'assets/fried fish.jpeg',
                    onSelected: () {
                      Navigator.pushNamed(context, '');
                      print('Panner selected');
                    },
                  ),
                  vegItem(
                    name: 'Chicken ',
                    price: '₹ 120',
                    rating: 4.9,
                    imageUrl: 'assets/chicken.png',
                    onSelected: () {
                      Navigator.pushNamed(context, '');
                      print('Chana masala selected');
                    },
                  ),
                  vegItem(
                    name: 'Fish Curry',
                    price: '₹ 90',
                    rating: 4.9,
                    imageUrl: 'assets/fish curry.jpg',
                    onSelected: () {
                      Navigator.pushNamed(context, '');
                      print('dal selected');
                    },
                  ),
                  vegItem(
                    name: 'Chicken Veg Noodles',
                    price: '₹ 40',
                    rating: 4.9,
                    imageUrl: 'assets/veg noodle.jpeg',
                    onSelected: () {
                      Navigator.pushNamed(context, '');
                      print('selected');
                    },
                  ),
                  vegItem(
                    name: 'Fried Fish Bangda',
                    price: '₹ 50',
                    rating: 4.9,
                    imageUrl: 'assets/fried fish bangda.jpeg',
                    onSelected: () {
                      Navigator.pushNamed(context, '');
                      print(' selected');
                    },
                  ),
                  // Add more items as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget vegItem({
    required String name,
    required String price,
    required double rating,
    required String imageUrl,
    required VoidCallback onSelected,
  }) {
    return GestureDetector(
      onTap: onSelected, // Trigger on image tap
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imageUrl,
                height: 90,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 4),
            Text(
              price,
              style: TextStyle(color: Colors.white),
            ),
            Row(
              children: [
                Icon(Icons.star, color: Colors.yellow, size: 16),
                SizedBox(width: 4),
                Text(
                  rating.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
