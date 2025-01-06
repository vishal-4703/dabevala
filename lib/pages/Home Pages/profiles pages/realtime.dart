import 'package:flutter/material.dart';
class realtime extends StatelessWidget {

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, 'ProfilePage');
                        },
                        child: Icon(Icons.arrow_back, color: Colors.black),
                      ),
                      Text(
                        'Food',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '');
                        },
                        child: Icon(Icons.favorite_border, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://images.ctfassets.net/3prze68gbwl1/asset-17suaysk1qa1i6d/1e3ba5e88bb9307b1039e4193edfca12/687474703a2f2f692e696d6775722e636f6d2f32355a673559422e676966.gif',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      'https://images.assetsdelivery.com/compings_v2/julialemba/julialemba2305/julialemba230500129.jpg',
                      height: 100,
                      width: 100,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Tracking Order',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'INVOICE : 12A394',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Arrived in',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      '10 : 32 min',
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.message, color: Colors.blue, size: 24),
                            SizedBox(height: 5),
                            Text('Message',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black)),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.phone, color: Colors.blue, size: 24),
                            SizedBox(height: 5),
                            Text('Call Driver',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'ORDER DETAILS',
                          style:
                          TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}