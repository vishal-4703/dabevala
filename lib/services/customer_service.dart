import '../models/customer.dart';

class CustomerService {
  Future<List<Customer>> fetchCustomers() async {
    // Simulate fetching data from an API
    await Future.delayed(Duration(seconds: 2));
    return [
      Customer(id: '1', name: 'Customer 1', address: 'Address 1', contact: '1111111111'),
      Customer(id: '2', name: 'Customer 2', address: 'Address 2', contact: '2222222222'),
    ];
  }
}
