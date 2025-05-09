import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/formations_page.dart';
import 'pages/participants_page.dart';
import 'pages/profile_page.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formation Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/formations': (context) => const FormationsPage(),
        '/participants': (context) => const ParticipantsPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
