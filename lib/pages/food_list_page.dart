import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:your_project_name/pages/model/food_item.dart';


class FoodListPage extends StatefulWidget {
  const FoodListPage({Key? key}) : super(key: key);

  @override
  State<FoodListPage> createState() => _FoodListPageState();
}

class _FoodListPageState extends State<FoodListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Items'),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance.ref('foodItems').onValue,
        builder: (context, snapshot) {
          // 1. Check connection state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Check errors
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // 3. If no data yet
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // 4. We have a DatabaseEvent
          final event = snapshot.data!;
          final dataSnapshot = event.snapshot;

          // Check if the node exists
          if (!dataSnapshot.exists) {
            return const Center(child: Text('No food items found.'));
          }

          // 5. dataSnapshot.value should be a List if your JSON is an array
          final data = dataSnapshot.value as List<dynamic>;

          // 6. Parse each map in the list into a FoodItem
          final List<FoodItem> foodItems = data.map((item) {
            return FoodItem.fromJson(item as Map<dynamic, dynamic>);
          }).toList();

          // 7. Display the items in a ListView
          return ListView.builder(
            itemCount: foodItems.length,
            itemBuilder: (context, index) {
              final item = foodItems[index];
              return ListTile(
                title: Text(item.title),
                subtitle: Text('Price: \$${item.price}'),
                leading: Image.asset(
                  item.imgUrl, // e.g. 'assets/biryani.png'
                  width: 50,
                  fit: BoxFit.cover,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
