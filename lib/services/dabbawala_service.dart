import '../models/dabbawala.dart';

class DabbawalaService {
  Future<List<Dabbawala>> fetchDabbawalas() async {
    // Simulate fetching data from an API
    await Future.delayed(Duration(seconds: 2));
    return [
      Dabbawala(id: '1', name: 'Dabbawala 1', contact: '9357545788', orderCount: 5),
      Dabbawala(id: '2', name: 'Dabbawala 2', contact: '9876543271', orderCount: 3),
      Dabbawala(id: '3', name: 'Dabbawala 3', contact: '9876345381', orderCount: 2),
      Dabbawala(id: '4', name: 'Dabbawala 4', contact: '8997543281', orderCount: 4),
      Dabbawala(id: '5', name: 'Dabbawala 5', contact: '9997543281', orderCount: 4),

    ];
  }
}
