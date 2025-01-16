FooditemList fooditemList = FooditemList(foodItems: [
  FoodItem(
    id: 1,
    title: "Chicken  Biryani",
    price:140 ,
    imgUrl:
    "'assets/biryani.png",
  ),
  FoodItem(
    id: 2,
    title: "Chicken ",
    price: 150,
    imgUrl:
    "assets/chicken.png",
  ),
  FoodItem(
    id: 3,
    title: " Shai Panner ",
    price: 120,
    imgUrl:
    "assets/sahipanir.png",
  ),
  FoodItem(
    id: 4,
    title: "Noddle",
    price: 120,
    imgUrl:
    "assets/veg noodle.jpeg",
  ),
  FoodItem(
    id: 5,
    title: "Panner",
    price: 120,
    imgUrl: "assets/panner.jpeg",
  ),

]);

class FooditemList {
  List<FoodItem> foodItems;

  FooditemList({required this.foodItems});
}

class FoodItem {
  int id;
  String title;
  double price;
  String imgUrl;
  int quantity;

  FoodItem({
    required this.id,
    required this.title,
    required this.price,
    required this.imgUrl,
    this.quantity = 1,
  });

  void incrementQuantity() {
    this.quantity = this.quantity + 1;
  }

  void decrementQuantity() {
    this.quantity = this.quantity - 1;
  }
}