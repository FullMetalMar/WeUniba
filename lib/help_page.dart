import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  static const Color bluScuro = Color(0xFF003366);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: bluScuro,
        title: const Text(
          'Aiuto',
          style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHelpButton(Icons.message, 'messaggi diretti'),
            const SizedBox(height: 16),
            _buildHelpButton(Icons.arrow_back, 'naviga indietro'),
            const SizedBox(height: 16),
            _buildHelpButton(Icons.people, 'chat e amici'),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpButton(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(30),
        color: bluScuro,
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Roboto',
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
