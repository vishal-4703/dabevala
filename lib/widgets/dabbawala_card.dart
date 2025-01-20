import 'package:flutter/material.dart';
import '../models/dabbawala.dart';

class DabbawalaCard extends StatelessWidget {
  final Dabbawala dabbawala;

  DabbawalaCard({required this.dabbawala});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(dabbawala.name),
        subtitle: Text(dabbawala.contact),
      ),
    );
  }
}
