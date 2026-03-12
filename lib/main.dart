import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const SorveteriaApp());
}

class SorveteriaApp extends StatelessWidget {
  const SorveteriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sorveteria - Menu Moderno',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}
