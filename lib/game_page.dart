import 'package:flutter/material.dart';
import 'subject_selection_page.dart';

const Color bluScuro = Color(0xFF003366);

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  void _navigateToSubjectSelection(BuildContext context, String gameType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubjectSelectionPage(gameType: gameType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: bluScuro,
        title: const Text(
          'Scegli il gioco',
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
            _buildButton(context, 'Quiz', (ctx) => _navigateToSubjectSelection(ctx, 'Quiz')),
            const SizedBox(height: 16),
            _buildButton(context, 'Cruciverba', (ctx) => _navigateToSubjectSelection(ctx, 'Cruciverba')),
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
}
