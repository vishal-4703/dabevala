class Dabbawala {
  final String id;
  final String name;
  final String contact; // Added contact field
  final int orderCount;

  Dabbawala({
    required this.id,
    required this.name,
    required this.contact, // Added here
    required this.orderCount,
  });

  // Factory method to create a Dabbawala from a Firebase document
  factory Dabbawala.fromMap(Map<String, dynamic> data) {
    return Dabbawala(
      id: data['id'] ?? '',
      name: data['name'] ?? 'Unknown',
      contact: data['contact'] ?? 'N/A', // Added here
      orderCount: data['orderCount'] ?? 0,
    );
  }
}
