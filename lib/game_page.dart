import 'package:flutter/material.dart';

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  String? selectedGame;
  String? selectedSubject;
  int currentQuestion = 0;
  int score = 0;
  bool answered = false;
  int? selectedOption;

  final List<String> games = ["Quiz", "Puzzle", "Memory"];
  final List<String> subjects = [
    "Matematica Discreta",
    "Programmazione",
    "Sistemi Operativi"
  ];

  final Map<String, List<QuizQuestion>> quizBySubject = {
    "Matematica Discreta": [
      QuizQuestion(
        question: "Qual è il complemento a uno di 010?",
        options: ["101", "100", "111"],
        correctIndex: 0,
      ),
    ],
    "Programmazione": [
      QuizQuestion(
        question: "Qual è la complessità media del quicksort?",
        options: ["O(n)", "O(n log n)", "O(n^2)"],
        correctIndex: 1,
      ),
    ],
    "Sistemi Operativi": [
      QuizQuestion(
        question: "Cos'è uno scheduler FIFO?",
        options: ["Priorità alta prima", "Ordine di arrivo", "Round Robin"],
        correctIndex: 1,
      ),
    ],
  };

  void checkAnswer(int index) {
    if (!answered) {
      setState(() {
        selectedOption = index;
        answered = true;
        if (index == quizBySubject[selectedSubject]![currentQuestion].correctIndex) {
          score += 10;
        }
      });
    }
  }

  void nextQuestion() {
    if (currentQuestion < quizBySubject[selectedSubject]!.length - 1) {
      setState(() {
        currentQuestion++;
        answered = false;
        selectedOption = null;
      });
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Quiz completato!"),
          content: Text("Hai totalizzato $score CFU 🎉"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  selectedGame = null;
                  selectedSubject = null;
                  currentQuestion = 0;
                  score = 0;
                  answered = false;
                  selectedOption = null;
                });
              },
              child: const Text("Torna alla selezione"),
            )
          ],
        ),
      );
    }
  }

  Widget buildSelectionScreen({
    required String title,
    required List<String> options,
    required void Function(String) onSelect,
  }) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF004070),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: options.map((option) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: const Color(0xFF003366),
                  foregroundColor: Colors.white,
                ),
                onPressed: () => onSelect(option),
                child: Text(option),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (selectedGame == null) {
      return buildSelectionScreen(
        title: "Seleziona un gioco",
        options: games,
        onSelect: (value) {
          if (value == "Quiz") {
            setState(() => selectedGame = value);
          }
        },
      );
    }

    if (selectedSubject == null) {
      return buildSelectionScreen(
        title: "Seleziona la materia",
        options: subjects,
        onSelect: (value) => setState(() => selectedSubject = value),
      );
    }

    final question = quizBySubject[selectedSubject]![currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: Text("${selectedSubject!} - Quiz"),
        backgroundColor: const Color(0xFF004070),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Domanda ${currentQuestion + 1}/${quizBySubject[selectedSubject]!.length}"),
            const SizedBox(height: 20),
            Text(question.question, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 30),
            ...List.generate(question.options.length, (index) {
              Color? buttonColor;
              if (answered) {
                if (index == question.correctIndex) {
                  buttonColor = Colors.green;
                } else if (index == selectedOption) {
                  buttonColor = Colors.red;
                } else {
                  buttonColor = Colors.grey.shade300;
                }
              }
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () => checkAnswer(index),
                  child: Text(question.options[index]),
                ),
              );
            }),
            const Spacer(),
            ElevatedButton(
              onPressed: answered ? nextQuestion : null,
              child: Text(currentQuestion < quizBySubject[selectedSubject]!.length - 1
                  ? "Prossima"
                  : "Fine"),
            )
          ],
        ),
      ),
    );
  }
}