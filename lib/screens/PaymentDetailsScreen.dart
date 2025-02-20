import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class PaymentDetailsScreen extends StatefulWidget {
  @override
  _PaymentDetailsScreenState createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  String? userId;
  bool isLoading = true;
  double totalPrice = 0.0;
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    fetchUserAndCartItems();
  }

  void fetchUserAndCartItems() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User is not signed in");
      setState(() => isLoading = false);
      return;
    }

    userId = user.uid;
    DatabaseReference ref = FirebaseDatabase.instance.ref("cartItems/$userId");

    ref.once().then((DatabaseEvent event) {
      print("Database Snapshot: ${event.snapshot.value}"); // Debugging print

      if (event.snapshot.exists && event.snapshot.value != null) {
        try {
          Map<String, dynamic> data =
          Map<String, dynamic>.from(event.snapshot.value as Map);
          double total = 0.0;
          List<Map<String, dynamic>> items = [];

          data.forEach((key, value) {
            if (value is Map) {
              double itemPrice =
                  double.tryParse(value["price"]?.toString() ?? "0.0") ?? 0.0;
              int quantity =
                  int.tryParse(value["quantity"]?.toString() ?? "1") ?? 1;
              double itemTotal = itemPrice * quantity;
              total += itemTotal;

              items.add({
                "name": value["name"] ?? "Unknown Item",
                "price": itemPrice,
                "quantity": quantity,
                "total": itemTotal,
              });
            }
          });

          setState(() {
            cartItems = items;
            totalPrice = total;
          });
        } catch (e) {
          print("Error parsing data: $e");
        }
      }
      setState(() => isLoading = false);
    }).catchError((error) {
      print("Error fetching cart items: $error");
      setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Confirmation'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Icon(Icons.check_circle, size: 100, color: Colors.teal),
                  SizedBox(height: 20),
                  Text(
                    'Payment Successful!',
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Transaction Number: 123456789',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 10),
            Text("Items Purchased:",
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            cartItems.isEmpty
                ? Center(
              child: Text("No items found.",
                  style: TextStyle(
                      fontSize: 16, color: Colors.redAccent)),
            )
                : Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return ListTile(
                    title: Text(item["name"],
                        style: TextStyle(
                            fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        "Qty: ${item["quantity"]} x ₹${item["price"].toStringAsFixed(2)}"),
                    trailing: Text(
                        "₹${item["total"].toStringAsFixed(2)}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                  );
                },
              ),
            ),
            Divider(),
            SizedBox(height: 10),
            Text(
              "Total Amount: ₹${totalPrice.toStringAsFixed(2)}",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            SizedBox(height: 10),
            Text(
              "Paid via Paytm",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }
}
