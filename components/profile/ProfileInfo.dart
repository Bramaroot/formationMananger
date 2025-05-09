import 'package:flutter/material.dart';
import '../ui/Card.dart' as custom;

class ProfileInfo extends StatelessWidget {
  final String username;

  const ProfileInfo({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return custom.Card(
      child: Column(
        children: [
          Text('Profil de $username'),
          const SizedBox(height: 16),
          Text('Email: user@example.com'),
          Text('Téléphone: +1234567890'),
        ],
      ),
    );
  }
}
