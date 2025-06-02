import 'package:flutter/material.dart';
import 'welcome_page.dart';

void main() {
  runApp(const WeUnibaApp());
}

class WeUnibaApp extends StatelessWidget {
  const WeUnibaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WeUniba',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const WelcomePage(), // Mostra la schermata di login all'avvio
      debugShowCheckedModeBanner: false,
    );
  }
}
