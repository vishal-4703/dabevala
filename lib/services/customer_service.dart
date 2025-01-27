import '../models/customer.dart';

class CustomerService {
  Future<List<Customer>> fetchCustomers() async {
    // Simulate fetching data from an API
    await Future.delayed(Duration(seconds: 2));
    return [

    ];
  }
}
