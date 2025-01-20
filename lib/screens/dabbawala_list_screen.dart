import 'package:flutter/material.dart';
import '../models/dabbawala.dart';
import '../services/dabbawala_service.dart';
import '../widgets/dabbawala_card.dart';

class DabbawalaListScreen extends StatelessWidget {
  final DabbawalaService dabbawalaService = DabbawalaService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dabbawala List'),
      ),
      body: FutureBuilder(
        future: dabbawalaService.fetchDabbawalas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Dabbawala> dabbawalas = snapshot.data ?? [];
            return ListView.builder(
              itemCount: dabbawalas.length,
              itemBuilder: (context, index) {
                return DabbawalaCard(dabbawala: dabbawalas[index]);
              },
            );
          }
        },
      ),
    );
  }
}
