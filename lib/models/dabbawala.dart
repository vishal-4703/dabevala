class Dabbawala {
  final String id;
  final String name;
  final String contact;
  final int orderCount;

  Dabbawala({
    required this.id,
    required this.name,
    required this.contact,
    required this.orderCount,
  });

  factory Dabbawala.fromMap(Map<dynamic, dynamic> data, String id) {
    return Dabbawala(
      id: id,
      name: data['name'] ?? 'No Name',
      contact: data['contact'] ?? 'N/A',
      orderCount: data['orderCount'] ?? 0,
    );
  }
}