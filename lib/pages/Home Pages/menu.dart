import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushNamed(context, 'FoodGoHomePage');
          },
        ),
        title: Text('Our Menu'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, 'card');
            },
          ),
          SizedBox(width: 15),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TabItem(
                  title: 'Meals',
                  isActive: true,
                  onPressed: () {
                    // Handle tab click
                    print("Meals tab clicked");
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(10),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                MenuItem(
                  assetImagePath: 'assets/sun.jpg',
                  title: 'Shai Panner',
                  day: 'SUNDAY',
                  onPressed: () {
                    Navigator.pushNamed(context,'sunday');
                  },
                ),
                MenuItem(
                  assetImagePath: 'assets/mon.webp',
                  title: 'Dal Chawal Puri',
                  day: 'MONDAY',
                  onPressed: () {
                    Navigator.pushNamed(context,'monday');
                  },
                ),
                MenuItem(
                  assetImagePath: 'assets/tue.webp',
                  title: 'Chana Masala Roti Rice',
                  day: 'TUESDAY',
                  onPressed: () {
                    Navigator.pushNamed(context,'tuesday');
                  },
                ),
                MenuItem(
                  assetImagePath: 'assets/wed.jpg',
                  title: 'Aalu Roti Rice',
                  day: 'WEDNESDAY',
                  onPressed: () {
                    Navigator.pushNamed(context,'wednesday');
                  },
                ),
                MenuItem(
                  assetImagePath: 'assets/thu.jpg',
                  title: 'Panner Roti Rice',
                  day: 'THURSDAY',
                  onPressed: () {
                    Navigator.pushNamed(context,'thursday');
                  },
                ),
                MenuItem(
                  assetImagePath: 'assets/fri.jpg',
                  title: 'Soyabin Roti Rice',
                  day: 'FRIDAY',
                  onPressed: () {
                    Navigator.pushNamed(context,'friday');
                  },
                ),
                MenuItem(
                  assetImagePath: 'assets/sat.jpg',
                  title: 'Rajma Roti Rice',
                  day: 'SATURDAY',
                  onPressed: () {
                    Navigator.pushNamed(context,'saturday');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TabItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onPressed;

  TabItem({required this.title, required this.isActive, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isActive ? Colors.orange : Colors.black,
            ),
          ),
          if (isActive)
            Container(
              margin: EdgeInsets.only(top: 5),
              height: 2,
              width: 20,
              color: Colors.orange,
            ),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String assetImagePath;
  final String title;
  final String day;
  final VoidCallback onPressed;

  MenuItem({
    required this.assetImagePath,
    required this.title,
    required this.day,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(assetImagePath),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 5),
            Text(
              day,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}