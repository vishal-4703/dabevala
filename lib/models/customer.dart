class Customer {
  final String id;
  final String email;
  final String username;

  Customer({required this.id, required this.email, required this.username});

  factory Customer.fromMap(Map<String, dynamic> data, String id) {
    return Customer(
        id: id,
        email: data['email'] ?? 'Unknown', // Default to 'Unknown' if email is missing
        username: data['username'] ?? 'Unknown' // Default to 'Unknown' if username is missing
    );
  }
}
