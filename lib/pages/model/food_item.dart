class FoodItem {
  final int id;
  final String title;
  final double price;
  final String imgUrl;

  FoodItem({
    required this.id,
    required this.title,
    required this.price,
    required this.imgUrl,
  });

  factory FoodItem.fromJson(Map<dynamic, dynamic> json) {
    return FoodItem(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(), // Convert to double
      imgUrl: json['imgUrl'] as String,
    );
  }
}
