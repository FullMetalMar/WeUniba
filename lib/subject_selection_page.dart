import 'package:flutter/material.dart';
import 'quiz_game_page.dart';
import 'crossword_game_page.dart';

const Color bluScuro = Color(0xFF004070);

class SubjectSelectionPage extends StatelessWidget {
  final String gameType;

  const SubjectSelectionPage({Key? key, required this.gameType}) : super(key: key);

  void _navigateToGame(BuildContext context, String subject) {
    if (gameType == 'Quiz') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuizGamePage(subject: subject),
        ),
      );
    } else if (gameType == 'Cruciverba') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CrosswordGamePage(subject: subject),
        ),
      );
    }
  }

  Widget _buildSubjectButton(BuildContext context, String subject) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _navigateToGame(context, subject),
        style: ElevatedButton.styleFrom(
          backgroundColor: bluScuro,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: const StadiumBorder(),
        ),
        child: Text(
          subject,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: bluScuro,
        title: Text(
          'Seleziona materia - $gameType',
          style: const TextStyle(color: Colors.white, fontFamily: 'Roboto'),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
        child: Column(
          children: [
            _buildSubjectButton(context, 'Programmazione'),
            const SizedBox(height: 16),
            _buildSubjectButton(context, 'Matematica Discreta'),
            const SizedBox(height: 16),
            _buildSubjectButton(context, 'Linguaggi Di Programmazione'),
          ],
        ),
      ),
    );
  }
}
