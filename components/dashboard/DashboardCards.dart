import 'package:flutter/material.dart';
import '../ui/Card.dart' as custom;

class DashboardCards extends StatelessWidget {
  const DashboardCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: [
        custom.Card(child: Text('Formations')),
        custom.Card(child: Text('Participants')),
        custom.Card(child: Text('Statistiques')),
        custom.Card(child: Text('Profil')),
      ],
    );
  }
}
