import 'package:flutter/material.dart';

const Color bluScuro = Color(0xFF004070);

class CrosswordGamePage extends StatefulWidget {
  final String subject;

  const CrosswordGamePage({Key? key, required this.subject}) : super(key: key);

  @override
  State<CrosswordGamePage> createState() => _CrosswordGamePageState();
}

class _CrosswordGamePageState extends State<CrosswordGamePage> {
  // Griglia 5x5 con lettere target e celle vuote iniziali
  final List<List<String?>> solutionGrid = [
    ['A', 'R', 'R', 'A', 'Y'],
    [null, null, 'I', null, null],
    [null, null, 'C', null, null],
    [null, null, 'I', null, null],
    ['B', 'U', 'G', null, null],
  ];

  List<List<String>> userGrid = List.generate(5, (_) => List.filled(5, ''));

  final String selectedDefinition = "Struttura di dati indicizzata (5 lettere)";

  void onCellTap(int row, int col) async {
    String? value = await showDialog(
      context: context,
      builder: (_) {
        String input = '';
        return AlertDialog(
          title: const Text("Inserisci una lettera"),
          content: TextField(
            maxLength: 1,
            textCapitalization: TextCapitalization.characters,
            onChanged: (val) => input = val.toUpperCase(),
            decoration: const InputDecoration(hintText: 'Lettera'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, input),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );

    /*if (value.isNotEmpty) {
      setState(() {
        userGrid[row][col] = value;
      });
    }*/
  }

  Widget buildCell(int row, int col) {
    final expected = solutionGrid[row][col];
    final userChar = userGrid[row][col];

    if (expected == null) {
      return const SizedBox.shrink(); // cella vuota
    }

    bool correct = userChar == expected;

    return GestureDetector(
      onTap: () => onCellTap(row, col),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: userChar.isEmpty
              ? Colors.white
              : (correct ? Colors.green.shade100 : Colors.red.shade100),
          border: Border.all(color: Colors.black),
        ),
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: Text(
          userChar,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  void checkSolution() {
    bool allCorrect = true;
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        if (solutionGrid[i][j] != null &&
            userGrid[i][j] != solutionGrid[i][j]) {
          allCorrect = false;
        }
      }
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(allCorrect ? "Bravo!" : "Riprova"),
        content: Text(
          allCorrect
              ? "Hai completato correttamente il cruciverba 🎉"
              : "Ci sono errori, controlla meglio.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bluScuro,
        title: Text(
          'Cruciverba - ${widget.subject}',
          style: const TextStyle(color: Colors.white, fontFamily: 'Roboto'),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              selectedDefinition,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (row) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (col) => buildCell(row, col)),
                );
              }),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkSolution,
              child: const Text("Verifica"),
            ),
          ],
        ),
      ),
    );
  }
}
