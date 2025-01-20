import '../models/dabbawala.dart';

class DabbawalaService {
  Future<List<Dabbawala>> fetchDabbawalas() async {
    // Simulate fetching data from an API
    await Future.delayed(Duration(seconds: 2));
    return [
      Dabbawala(id: '1', name: 'Dabbawala 1', contact: '1234567890'),
      Dabbawala(id: '2', name: 'Dabbawala 2', contact: '0987654321'),
    ];
  }
}
