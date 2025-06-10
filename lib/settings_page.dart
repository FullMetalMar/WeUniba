import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const Color bluScuro = Color(0xFF003366);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: bluScuro,
        title: const Text(
          'Impostazioni',
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
            _buildButton(context, 'Lingua', _showLanguageDialog),
            const SizedBox(height: 16),
            _buildButton(context, 'Info Applicazione', _showInfoDialog),
            const SizedBox(height: 16),
            _buildButton(context, 'Crediti', _showCreditsDialog),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String text,
    void Function(BuildContext) onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => onPressed(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: bluScuro,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: const StadiumBorder(),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Seleziona Lingua'),
        content: DropdownButtonFormField<String>(
          value: 'Italiano',
          items: const [
            DropdownMenuItem(value: 'Italiano', child: Text('Italiano')),
            DropdownMenuItem(value: 'Inglese', child: Text('Inglese')),
            DropdownMenuItem(value: 'Spagnolo', child: Text('Spagnolo')),
          ],
          onChanged: (value) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Lingua selezionata: $value')),
            );
          },
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text('Info Applicazione'),
        content: Text(
          'WeUniba v1.0.0\n\nApp per studenti UNIBA.\nSupporta studio, gioco e socializzazione.',
        ),
      ),
    );
  }

  void _showCreditsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text('Crediti'),
        content: Text(
          'Sviluppato da:\n- Silvio Forgione\n- Silvia Saettone\n- Marco Padovano\n\nMade with Flutter ❤️',
        ),
      ),
    );
  }
}
