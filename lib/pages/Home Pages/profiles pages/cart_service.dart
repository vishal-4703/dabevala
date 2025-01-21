import 'package:firebase_database/firebase_database.dart';

class CartService {
  final DatabaseReference _cartRef = FirebaseDatabase.instance.ref().child('cart');

  Stream<DatabaseEvent> get cartStream => _cartRef.onValue;

  void addItemToCart(String id, String name, String day, String imagePath, double price) {
    _cartRef.child(id).set({
      'itemName': name,
      'day': day,
      'assetImagePath': imagePath,
      'price': price,
    });
  }

  void updateCartItem(String id, String newName, double newPrice, String newDay, String newImagePath) {
    _cartRef.child(id).update({
      'itemName': newName,
      'price': newPrice,
      'day': newDay,
      'assetImagePath': newImagePath,
    });
  }

  void deleteCartItem(String id) {
    _cartRef.child(id).remove();
  }
}
