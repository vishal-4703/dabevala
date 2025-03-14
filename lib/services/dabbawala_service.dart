import '../models/dabbawala.dart';

class DabbawalaService {
  Future<List<Dabbawala>> fetchDabbawalas() async {
    // Simulate fetching data from an API
    await Future.delayed(Duration(seconds: 2));
    return [
      Dabbawala(id: '1', name: 'kishor', contact: '9357545788', orderCount: 5),
      Dabbawala(id: '2', name: 'kumar', contact: '9876543271', orderCount: 3),

    ];
  }
}
