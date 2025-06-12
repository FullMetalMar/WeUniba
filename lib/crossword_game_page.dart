import 'package:flutter/material.dart';
import 'session_data.dart';

class CrosswordGamePage extends StatefulWidget {
  final String subject;
  const CrosswordGamePage({super.key, required this.subject});

  @override
  State<CrosswordGamePage> createState() => _CrosswordGamePageState();
}

class _CrosswordGamePageState extends State<CrosswordGamePage> {
  late List<List<String?>> solutionGrid;
  late List<List<String>> userGrid;
  late List<List<Color>> cellColors;
  late Map<int, String> definitions;
  late Map<String, List<dynamic>> wordMap;
  late Map<String, Object> puzzle;
  Map<Point, int> cellNumbers = {};
  Point? activeCell;
  final _focusNodes = <Point, FocusNode>{};
  final Set<Point> lockedCells = {};
  final Map<Point, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    puzzle = _getPuzzle(widget.subject);
    solutionGrid = _cropGrid(puzzle['grid'] as List<List<String?>>);
    definitions = puzzle['definitions'] as Map<int, String>;
    wordMap = puzzle['wordMap'] as Map<String, List<dynamic>>;
    userGrid = List.generate(
      solutionGrid.length,
      (i) => List.filled(solutionGrid[i].length, ''),
    );
    for (int row = 0; row < solutionGrid.length; row++) {
      for (int col = 0; col < solutionGrid[row].length; col++) {
        final point = Point(row, col);
        _controllers[point] = TextEditingController();
      }
    }
    cellColors = List.generate(
      solutionGrid.length,
      (i) => List.filled(solutionGrid[i].length, Colors.grey[200]!),
    );
    _initCellNumbers();
  }

  void _initCellNumbers() {
    cellNumbers.clear();
    final gridRaw = puzzle['grid'] as List<List<String?>>;
    final crop = _cropGrid(gridRaw);
    final cropOffset = _getCropOffset(gridRaw, crop);

    for (var word in wordMap.entries) {
      int number = word.value[0] as int;
      int row = word.value[2] - cropOffset['row']!;
      int col = word.value[3] - cropOffset['col']!;
      cellNumbers[Point(row, col)] = number;
    }
  }

  Map<String, int> _getCropOffset(List<List<String?>> original, List<List<String?>> cropped) {
    int rowOffset = 0;
    while (rowOffset < original.length && original[rowOffset].every((cell) => cell == null)) {
      rowOffset++;
    }

    int colOffset = 0;
    while (colOffset < original[0].length && original.every((row) => row[colOffset] == null)) {
      colOffset++;
    }

    return {'row': rowOffset, 'col': colOffset};
  }

  List<List<String?>> _cropGrid(List<List<String?>> grid) {
    int top = 0, bottom = grid.length - 1;
    int left = 0, right = grid[0].length - 1;
    while (top <= bottom && grid[top].every((cell) => cell == null)) top++;
    while (bottom >= top && grid[bottom].every((cell) => cell == null)) bottom--;
    while (left <= right && grid.every((row) => row[left] == null)) left++;
    while (right >= left && grid.every((row) => row[right] == null)) right--;
    return [
      for (int i = top; i <= bottom; i++)
        [for (int j = left; j <= right; j++) grid[i][j]],
    ];
  }

  Map<String, Object> _getPuzzle(String subject) {
    
    T randomChoice<T>(List<T> list) {
  final index = DateTime.now().millisecondsSinceEpoch % list.length;
  return list[index];
}
    List<List<String?>> grid = List.generate(
      7,
      (_) => List<String?>.filled(7, null),
    );
    Map<int, String> defs = {};
    Map<String, List<dynamic>> map = {};
    int id = 1;

    void add(String word, String dir, int r, int c, String def) {
      defs[id] = def;
      map[word] = [id, dir, r, c];
      for (int i = 0; i < word.length; i++) {
        if (dir == 'H')
          grid[r][c + i] = word[i];
        else
          grid[r + i][c] = word[i];
      }
      id++;
    }

    if (subject == 'Programmazione') {
      final List<Map<String, Object>> puzzles = [
        {
          'words': [
            ["ARRAY", "H", 0, 0, "Struttura di dati indicizzata"],
            ["STACK", "H", 1, 0, "Struttura dati LIFO"],
            ["QUEUE", "H", 2, 0, "Struttura dati FIFO"],
            ["LOOP", "H", 3, 0, "Costrutto per ripetizione"],
            ["CLASS", "H", 4, 0, "Modello per oggetti"]
          ]
        },
        {
          'words': [
            ["WHILE", "H", 0, 0, "Tipo di ciclo basato su condizione"],
            ["FLOAT", "H", 1, 0, "Tipo di dato con virgola"],
            ["SWITCH", "H", 2, 0, "Controllo multiplo di flusso"],
            ["RETURN", "H", 3, 0, "Istruzione per uscita da funzione"],
            ["BREAK", "H", 4, 0, "Termina ciclo o switch"]
          ]
        },
        {
          'words': [
            ["PRINT", "H", 0, 0, "Stampa un output"],
            ["INPUT", "H", 1, 0, "Riceve un dato dall'utente"],
            ["DEBUG", "H", 2, 0, "Analisi di errori nel codice"],
            ["CONST", "H", 3, 0, "Costante in un programma"],
            ["LOGIC", "H", 4, 0, "Fondamento del controllo di flusso"]
          ]
        },
        {
          'words': [
            ["INDEX", "H", 0, 0, "Posizione in una struttura"],
            ["PARAM", "H", 1, 0, "Parametro di una funzione"],
            ["EXCEPT", "H", 2, 0, "Errore gestito nel codice"],
            ["IMPORT", "H", 3, 0, "Inclusione di librerie"],
            ["STATIC", "H", 4, 0, "Parola chiave di visibilità"],
          ]
        },
        {
          'words': [
            ["PUBLIC", "H", 0, 0, "Modificatore di accesso"],
            ["MODULE", "H", 1, 0, "Unità di codice riutilizzabile"],
            ["OBJECT", "H", 2, 0, "Istanza di una classe"],
            ["SCRIPT", "H", 3, 0, "Programma interpretabile"],
            ["METHOD", "H", 4, 0, "Funzione di una classe"]
          ]
        }
      ];

      var puzzleChoice = randomChoice(puzzles);
      grid = List.generate(10, (_) => List<String?>.filled(10, null));
      defs.clear();
      map.clear();
      int id = 1;
      for (var word in puzzleChoice['words'] as List<List<dynamic>>) {
        add(word[0] as String, word[1] as String, word[2] as int, word[3] as int, word[4] as String);
      }
    } else if (subject == 'Matematica Discreta') {
      final List<Map<String, Object>> puzzles = [
        {
          'words': [
            ["GRAFO", "H", 0, 0, "Struttura composta da nodi e archi"],
            ["INSIEME", "H", 1, 0, "Collezione di elementi"],
            ["PROVA", "H", 2, 0, "Metodo per dimostrare"],
            ["ARCO", "H", 3, 0, "Collegamento tra vertici"],
            ["LOGICA", "H", 4, 0, "Studio del ragionamento"]
          ]
        },
        {
          'words': [
            ["VERTICE", "H", 0, 0, "Nodo di un grafo"],
            ["NUMERI", "H", 1, 0, "Oggetti dello studio matematico"],
            ["TEOREMA", "H", 2, 0, "Affermazione dimostrata"],
            ["INSIEMI", "H", 3, 0, "Raggruppamenti di oggetti"],
            ["REL", "H", 4, 0, "Abbreviazione di relazione"]
          ]
        },
        {
          'words': [
            ["CICLO", "H", 0, 0, "Sequenza ripetuta di passi"],
            ["NODO", "H", 1, 0, "Elemento di un grafo"],
            ["ARCO", "H", 2, 0, "Connessione tra nodi"],
            ["CARD", "H", 3, 0, "Numero di elementi in un insieme"],
            ["NEG", "H", 4, 0, "Simbolo di negazione"]
          ]
        },
        {
          'words': [
            ["GRAFICO", "H", 0, 0, "Rappresentazione visiva di dati"],
            ["ELEMENTO", "H", 1, 0, "Singola entità di un insieme"],
            ["OPERATORE", "H", 2, 0, "Simbolo che indica operazione"],
            ["CONGIUNZIONE", "H", 3, 0, "Operatore logico AND"],
            ["DISGIUNZIONE", "H", 4, 0, "Operatore logico OR"]
          ]
        },
        {
          'words': [
            ["QUANTIFICATORE", "H", 0, 0, "Simbolo per 'tutti' o 'esiste'"],
            ["FORMULA", "H", 1, 0, "Espressione logica"],
            ["DIMOSTRAZIONE", "H", 2, 0, "Procedura per convalidare un teorema"],
            ["IMPLICAZIONE", "H", 3, 0, "Relazione logica tra proposizioni"],
            ["VERITA", "H", 4, 0, "Stato logico positivo"]
          ]
        }
      ];

      var puzzleChoice = randomChoice(puzzles);
      grid = List.generate(10, (_) => List<String?>.filled(10, null));
      defs.clear();
      map.clear();
      int id = 1;
      for (var word in puzzleChoice['words'] as List<List<dynamic>>) {
        add(word[0] as String, word[1] as String, word[2] as int, word[3] as int, word[4] as String);
      }
    } else if (subject == 'Linguaggi Di Programmazione') {
      final List<Map<String, Object>> puzzles = [
        {
          'words': [
            ["JAVA", "H", 0, 0, "Linguaggio OOP molto diffuso"],
            ["PYTHON", "H", 1, 0, "Linguaggio dinamico ad alto livello"],
            ["RUBY", "H", 2, 0, "Linguaggio orientato agli oggetti"],
            ["KOTLIN", "H", 3, 0, "Moderno linguaggio per Android"],
            ["SWIFT", "H", 4, 0, "Linguaggio Apple per iOS"]
          ]
        },
        {
          'words': [
            ["C", "H", 0, 0, "Linguaggio base imperativo"],
            ["CPP", "H", 1, 0, "Estensione di C"],
            ["PHP", "H", 2, 0, "Linguaggio per il web"],
            ["PERL", "H", 3, 0, "Simile a Ruby"],
            ["GO", "H", 4, 0, "Sviluppato da Google"]
          ]
        },
        {
          'words': [
            ["RUST", "H", 0, 0, "Linguaggio sicuro e moderno"],
            ["SCALA", "H", 1, 0, "Combina OOP e funzionale"],
            ["HASKELL", "H", 2, 0, "Funzionale puro"],
            ["TYPESCRIPT", "H", 3, 0, "Superset di JavaScript"],
            ["DART", "H", 4, 0, "Usato per Flutter"]
          ]
        },
        {
          'words': [
            ["HTML", "H", 0, 0, "Markup per il web"],
            ["CSS", "H", 1, 0, "Stile per il web"],
            ["JAVASCRIPT", "H", 2, 0, "Linguaggio dinamico per il browser"],
            ["SQL", "H", 3, 0, "Linguaggio per database"],
            ["BASH", "H", 4, 0, "Shell per Linux"]
          ]
        },
        {
          'words': [
            ["ELIXIR", "H", 0, 0, "Linguaggio funzionale per applicazioni scalabili"],
            ["LUA", "H", 1, 0, "Linguaggio usato nei giochi"],
            ["FORTRAN", "H", 2, 0, "Linguaggio scientifico"],
            ["COBOL", "H", 3, 0, "Vecchio linguaggio per business"],
            ["F#", "H", 4, 0, "Linguaggio .NET funzionale"]
          ]
        }
      ];

      var puzzleChoice = randomChoice(puzzles);
      grid = List.generate(10, (_) => List<String?>.filled(10, null));
      defs.clear();
      map.clear();
      int id = 1;
      for (var word in puzzleChoice['words'] as List<List<dynamic>>) {
        add(word[0] as String, word[1] as String, word[2] as int, word[3] as int, word[4] as String);
      }
    } else {
      defs[0] = 'Materia non supportata';
    }

    return {'grid': grid, 'definitions': defs, 'wordMap': map};
  }

  bool isPuzzleCompleted() {
    for (int row = 0; row < solutionGrid.length; row++) {
      for (int col = 0; col < solutionGrid[row].length; col++) {
        final solutionChar = solutionGrid[row][col];
        if (solutionChar != null && userGrid[row][col] != solutionChar) {
          return false;
        }
      }
    }
    return true;
  }

  Widget buildCell(int row, int col) {
    final expected = solutionGrid[row][col];
    final point = Point(row, col);
    final number = cellNumbers[point];

    if (expected == null) {
      return Container(
        width: 30,
        height: 30,
        margin: const EdgeInsets.all(1),
        color: Colors.black12,
      );
    }

    _focusNodes.putIfAbsent(point, () {
      final node = FocusNode();
      node.addListener(() {
        if (node.hasFocus) {
          setState(() {
            activeCell = point;
          });
        }
      });
      return node;
    });

    final isActive = activeCell == point;
    final borderColor = isActive ? Colors.blueAccent : Colors.black26;

    return Container(
      width: 30,
      height: 30,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: cellColors[row][col],
        border: Border.all(color: borderColor, width: isActive ? 2 : 1),
      ),
      child: Stack(
        children: [
          if (number != null)
            Positioned(
              top: 1,
              left: 2,
              child: Text(
                number.toString(),
                style: const TextStyle(fontSize: 8),
              ),
            ),
          Center(
            child: TextField(
              controller: _controllers[point],
              focusNode: _focusNodes[point],
              readOnly: lockedCells.contains(point),
              maxLength: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.zero,
              ),
              onTap: () {
                setState(() {
                  activeCell = point;
                });
              },
              onChanged: (value) {
                if (value.isNotEmpty) {
                  final input = value.substring(value.length - 1).toUpperCase();
                  final expectedChar = expected;

                  userGrid[row][col] = input;
                  _controllers[point]!.value = TextEditingValue(
                    text: input,
                    selection: TextSelection.collapsed(offset: 1),
                  );

                  setState(() {
                    if (input == expectedChar) {
                      cellColors[row][col] = Colors.greenAccent.shade100;
                      lockedCells.add(point);

                      for (int nextCol = col + 1; nextCol < solutionGrid[row].length; nextCol++) {
                        final nextPoint = Point(row, nextCol);
                        if (solutionGrid[row][nextCol] != null && !lockedCells.contains(nextPoint)) {
                          activeCell = nextPoint;
                          _focusNodes[nextPoint]?.requestFocus();
                          break;
                        }
                      }
                    } else {
                      cellColors[row][col] = Colors.redAccent.shade100;
                    }
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cruciverba - ${widget.subject}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF004070),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: List.generate(solutionGrid.length, (row) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    solutionGrid[row].length,
                    (col) => buildCell(row, col),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            const Text(
              'Definizioni',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...definitions.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text('${e.key}. ${e.value}', textAlign: TextAlign.left),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004070),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (isPuzzleCompleted()) {
                    SessionData.aggiungiCFU(30);
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Complimenti!"),
                        content: const Text("Hai completato correttamente il cruciverba e guadagnato 30 CFU!"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Non tutte le risposte sono corrette!")),
                    );
                  }
                },
                child: const Text("Verifica Cruciverba"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Point {
  final int row;
  final int col;

  const Point(this.row, this.col);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point && runtimeType == other.runtimeType && row == other.row && col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;
}
