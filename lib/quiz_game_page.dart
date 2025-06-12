import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

const Color bluScuro = Color(0xFF004070);
const Color verde = Colors.green;
const Color rosso = Colors.red;

class QuizGamePage extends StatefulWidget {
  final String subject;

  const QuizGamePage({Key? key, required this.subject}) : super(key: key);

  @override
  State<QuizGamePage> createState() => _QuizGamePageState();
}

class _QuizGamePageState extends State<QuizGamePage> with TickerProviderStateMixin {
  late List<Question> selectedQuestions;
  int currentIndex = 0;
  int correctAnswers = 0;
  String? selectedAnswer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    selectedQuestions = _getRandomQuestions(widget.subject);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    _startAnimations();
  }

  void _startAnimations() {
    _fadeController.reset();
    _slideController.reset();
    _fadeController.forward();
    _slideController.forward();
  }

  List<Question> _getRandomQuestions(String subject) {
    final allQuestions = quizDatabase[subject] ?? [];
    allQuestions.shuffle(Random());
    return allQuestions.take(5).toList();
  }

  Future<void> _answerQuestion(String answer) async {
    if (selectedAnswer != null) return;

    final correct = selectedQuestions[currentIndex].correctAnswer;
    setState(() {
      selectedAnswer = answer;
      if (answer == correct) {
        correctAnswers++;
      }
    });

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(
        AssetSource(answer == correct ? 'sounds/correct.mp3' : 'sounds/wrong.mp3'),
      );
    } catch (e) {
      debugPrint("Errore riproduzione suono: $e");
    }
  }

  Future<void> _nextQuestion() async {
    await _fadeController.reverse(); // fade out

    setState(() {
      currentIndex++;
      selectedAnswer = null;
    });

    _startAnimations();
  }

  void _showResult() {
    int cfu = 0;
    switch (correctAnswers) {
      case 2:
        cfu = 10;
        break;
      case 3:
        cfu = 15;
        break;
      case 4:
        cfu = 25;
        break;
      case 5:
        cfu = 40;
        break;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Risultato"),
        content: Text("Hai risposto correttamente a $correctAnswers/5 domande.\nHai guadagnato $cfu CFU."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionContent() {
    final question = selectedQuestions[currentIndex];
    final correct = question.correctAnswer;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeController,
        child: Column(
          key: ValueKey(currentIndex),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LinearProgressIndicator(
              value: (currentIndex + 1) / 5,
              color: bluScuro,
              backgroundColor: Colors.grey.shade300,
              minHeight: 8,
            ),
            const SizedBox(height: 20),
            Text(
              'Domanda ${currentIndex + 1}/5',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              question.text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ...question.options.map((opt) {
              Color buttonColor = Colors.grey.shade300;
              if (selectedAnswer != null) {
                if (opt == correct) {
                  buttonColor = verde;
                } else if (opt == selectedAnswer && opt != correct) {
                  buttonColor = rosso;
                } else {
                  buttonColor = Colors.grey.shade400;
                }
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.black,
                      disabledBackgroundColor: buttonColor,
                      disabledForegroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: selectedAnswer == null ? () => _answerQuestion(opt) : null,
                    child: Text(opt, style: const TextStyle(fontSize: 16)),
                  ),
                ),
              );
            }).toList(),
            if (selectedAnswer != null)
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: ElevatedButton(
                  onPressed: currentIndex < 4 ? _nextQuestion : _showResult,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bluScuro,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    currentIndex < 4 ? 'Prossima domanda' : 'Vedi risultato',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bluScuro,
        title: Text(
          'Quiz - ${widget.subject}',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _buildQuestionContent(),
        ),
      ),
    );
  }
}

class Question {
  final String text;
  final List<String> options;
  final String correctAnswer;

  Question({required this.text, required this.options, required this.correctAnswer});
}

final Map<String, List<Question>> quizDatabase = {
  'Programmazione': [
  Question(text: 'Cos\'è una variabile?', options: ['Una costante', 'Uno spazio di memoria con nome', 'Un tipo di dato', 'Una funzione'], correctAnswer: 'Uno spazio di memoria con nome'),
  Question(text: 'Cosa fa un ciclo for?', options: ['Ripete un\'azione finché una condizione è vera', 'Definisce una funzione', 'Esegue codice una sola volta', 'Dichiara una variabile'], correctAnswer: 'Ripete un\'azione finché una condizione è vera'),
  Question(text: 'Quale simbolo si usa per commenti su una riga in C?', options: ['//', '/* */', '#', '--'], correctAnswer: '//'),
  Question(text: 'Cosa stampa: printf("%d", 3 + 2 * 2);', options: ['10', '7', '9', '8'], correctAnswer: '7'),
  Question(text: 'Che tipo di linguaggio è C?', options: ['Interpretato', 'Compilato', 'Visuale', 'Markup'], correctAnswer: 'Compilato'),
  Question(text: 'Cos\'è un array?', options: ['Un tipo di funzione', 'Un tipo di ciclo', 'Una collezione indicizzata di dati', 'Una variabile numerica'], correctAnswer: 'Una collezione indicizzata di dati'),
  Question(text: 'Cosa fa un return?', options: ['Interrompe un ciclo', 'Chiama una funzione', 'Restituisce un valore', 'Definisce un array'], correctAnswer: 'Restituisce un valore'),
  Question(text: 'Quale estensione ha un file C?', options: ['.py', '.cpp', '.c', '.java'], correctAnswer: '.c'),
  Question(text: 'Cosa rappresenta NULL in C?', options: ['0', 'Un carattere vuoto', 'Un puntatore a nulla', 'Un array vuoto'], correctAnswer: 'Un puntatore a nulla'),
  Question(text: 'Cosa fa la funzione scanf in C?', options: ['Stampa a schermo', 'Legge da input', 'Scrive su file', 'Compila il programma'], correctAnswer: 'Legge da input'),
  Question(text: 'Il costrutto if serve a:', options: ['Definire variabili', 'Controllare condizioni', 'Stampare a video', 'Leggere file'], correctAnswer: 'Controllare condizioni'),
  Question(text: 'Qual è il valore iniziale di una variabile globale non inizializzata in C?', options: ['1', 'Random', '0', 'NULL'], correctAnswer: '0'),
  Question(text: 'Come si scrive un ciclo infinito in C?', options: ['for(;;)', 'for(1)', 'while(false)', 'do while(0)'], correctAnswer: 'for(;;)'),
  Question(text: 'Qual è la funzione principale di un programma in C?', options: ['init()', 'start()', 'main()', 'first()'], correctAnswer: 'main()'),
  Question(text: 'Cosa significa "compilare"?', options: ['Tradurre codice in linguaggio macchina', 'Scrivere codice', 'Eseguire codice', 'Leggere codice'], correctAnswer: 'Tradurre codice in linguaggio macchina'),
  Question(text: 'Cos\'è una funzione ricorsiva?', options: ['Una funzione che si chiama da sola', 'Una funzione con parametri', 'Una funzione in un ciclo', 'Una funzione definita dopo il main'], correctAnswer: 'Una funzione che si chiama da sola'),
  Question(text: 'Quale operatore serve per assegnare un valore?', options: ['==', '=', '!=', ':='], correctAnswer: '='),
  Question(text: 'Come si dichiara un intero?', options: ['int x;', 'integer x;', 'num x;', 'int = x;'], correctAnswer: 'int x;'),
  Question(text: 'Come si chiude correttamente un blocco in C?', options: ['()', '{}', '[]', '<>'], correctAnswer: '{}'),
  Question(text: 'Quale simbolo indica il modulo?', options: ['%', '*', '/', '&'], correctAnswer: '%'),
],

'Matematica Discreta': [
  Question(text: 'Un numero primo è...', options: ['Divisibile solo per 1 e se stesso', 'Sempre pari', 'Multiplo di 3', 'Divisibile per 2 e 3'], correctAnswer: 'Divisibile solo per 1 e se stesso'),
  Question(text: 'Il minimo comune multiplo tra 4 e 6 è:', options: ['12', '24', '6', '8'], correctAnswer: '12'),
  Question(text: 'L’insieme dei numeri naturali include:', options: ['0, 1, 2, 3...', '..., -2, -1, 0, 1...', 'Numeri decimali', 'Numeri immaginari'], correctAnswer: '0, 1, 2, 3...'),
  Question(text: 'Il complemento dell’insieme A rispetto all’universo U è:', options: ['U \\ A', 'A ∩ B', 'A ∪ B', 'A × B'], correctAnswer: 'U \\ A'),
  Question(text: 'Il grafo completo con 4 vertici ha:', options: ['6 archi', '4 archi', '8 archi', '3 archi'], correctAnswer: '6 archi'),
  Question(text: 'Due insiemi sono disgiunti se:', options: ['Non hanno elementi in comune', 'Uno è sottoinsieme dell’altro', 'Sono infiniti', 'Sono uguali'], correctAnswer: 'Non hanno elementi in comune'),
  Question(text: 'Una proposizione è:', options: ['Una frase vera o falsa', 'Un insieme', 'Un numero', 'Un vettore'], correctAnswer: 'Una frase vera o falsa'),
  Question(text: 'Il numero binario 101 equivale a:', options: ['5', '4', '3', '6'], correctAnswer: '5'),
  Question(text: 'La negazione di "A e B" è:', options: ['Non A o non B', 'A o B', 'A e non B', 'Non A e non B'], correctAnswer: 'Non A o non B'),
  Question(text: 'La cardinalità di un insieme è:', options: ['Il numero dei suoi elementi', 'Il numero di insiemi', 'Il valore minimo', 'La somma degli elementi'], correctAnswer: 'Il numero dei suoi elementi'),
  Question(text: 'A ⊆ B significa che:', options: ['A è sottoinsieme di B', 'A è maggiore di B', 'A è disgiunto da B', 'B è sottoinsieme di A'], correctAnswer: 'A è sottoinsieme di B'),
  Question(text: 'Una relazione è simmetrica se:', options: ['(a,b) ∈ R ⇒ (b,a) ∈ R', 'R ⊆ A', '(a,a) ∈ R', 'Ogni elemento ha immagine unica'], correctAnswer: '(a,b) ∈ R ⇒ (b,a) ∈ R'),
  Question(text: 'Il numero di sottoinsiemi di un insieme con 3 elementi è:', options: ['8', '3', '6', '9'], correctAnswer: '8'),
  Question(text: 'Il principio del buon ordinamento afferma che:', options: ['Ogni insieme non vuoto di N ha un minimo', 'Ogni insieme ha un massimo', 'N è finito', 'Ogni insieme ha un ordinamento'], correctAnswer: 'Ogni insieme non vuoto di N ha un minimo'),
  Question(text: 'La tabella di verità è:', options: ['Rappresentazione di proposizioni logiche', 'Un tipo di grafo', 'Un insieme di numeri', 'Un sistema lineare'], correctAnswer: 'Rappresentazione di proposizioni logiche'),
  Question(text: 'Un grafo connesso ha:', options: ['Un cammino tra ogni coppia di vertici', 'Solo 2 vertici', 'Nessun ciclo', 'Tutti archi orientati'], correctAnswer: 'Un cammino tra ogni coppia di vertici'),
  Question(text: 'Il prodotto cartesiano A × B è:', options: ['Insieme delle coppie (a,b)', 'Unione di A e B', 'Intersezione tra A e B', 'Insieme dei quadrati'], correctAnswer: 'Insieme delle coppie (a,b)'),
  Question(text: 'Un insieme è finito se:', options: ['Ha un numero limitato di elementi', 'È disgiunto', 'Contiene 0', 'Contiene solo numeri pari'], correctAnswer: 'Ha un numero limitato di elementi'),
  Question(text: 'La funzione identità è:', options: ['f(x) = x', 'f(x) = 0', 'f(x) = x²', 'f(x) = 1/x'], correctAnswer: 'f(x) = x'),
  Question(text: 'L’implicazione A ⇒ B è falsa quando:', options: ['A è vera e B è falsa', 'A e B sono vere', 'A è falsa', 'B è vera'], correctAnswer: 'A è vera e B è falsa'),
],

'Linguaggi Di Programmazione': [
  Question(text: 'Cos\'è un linguaggio di programmazione?', options: ['Un linguaggio per comunicare con il computer', 'Un dizionario', 'Un framework', 'Un sistema operativo'], correctAnswer: 'Un linguaggio per comunicare con il computer'),
  Question(text: 'Quale tra questi è un linguaggio imperativo?', options: ['C', 'HTML', 'Prolog', 'SQL'], correctAnswer: 'C'),
  Question(text: 'Il paradigma funzionale si basa su:', options: ['Funzioni pure e immutabilità', 'Classi e oggetti', 'Goto', 'Cicli for'], correctAnswer: 'Funzioni pure e immutabilità'),
  Question(text: 'Cosa sono i tipi statici?', options: ['Tipi determinati a tempo di compilazione', 'Tipi cambiabili in runtime', 'Tipi che cambiano automaticamente', 'Solo interi'], correctAnswer: 'Tipi determinati a tempo di compilazione'),
  Question(text: 'Python è un linguaggio:', options: ['Dinamico e interpretato', 'Compilato e statico', 'Procedurale solo', 'Visuale'], correctAnswer: 'Dinamico e interpretato'),
  Question(text: 'In Java, tutto è contenuto in:', options: ['Classi', 'Moduli', 'File', 'Funzioni'], correctAnswer: 'Classi'),
  Question(text: 'Il simbolo == in molti linguaggi serve per:', options: ['Confrontare due valori', 'Assegnare un valore', 'Somma', 'Concatenare'], correctAnswer: 'Confrontare due valori'),
  Question(text: 'Quale linguaggio è fortemente tipizzato?', options: ['Java', 'JavaScript', 'PHP', 'Bash'], correctAnswer: 'Java'),
  Question(text: 'L’interprete è:', options: ['Un esecutore riga per riga', 'Un compilatore', 'Un editor di codice', 'Un debugger'], correctAnswer: 'Un esecutore riga per riga'),
  Question(text: 'Un linguaggio dichiarativo:', options: ['Specifica cosa fare, non come', 'Specifica passi dettagliati', 'Non ha sintassi', 'È sempre visuale'], correctAnswer: 'Specifica cosa fare, non come'),
  Question(text: 'Cos’è la garbage collection?', options: ['Gestione automatica della memoria', 'Un tipo di algoritmo', 'Una funzione di stampa', 'Un bug'], correctAnswer: 'Gestione automatica della memoria'),
  Question(text: 'Un linguaggio Turing completo può:', options: ['Simulare qualsiasi algoritmo', 'Solo stampare a schermo', 'Eseguire script HTML', 'Essere solo interpretato'], correctAnswer: 'Simulare qualsiasi algoritmo'),
  Question(text: 'JavaScript è utilizzato principalmente per:', options: ['Programmazione web', 'Compilazione C', 'Calcolo simbolico', 'App desktop'], correctAnswer: 'Programmazione web'),
  Question(text: 'In C++, cout serve per:', options: ['Stampare su console', 'Commentare', 'Leggere input', 'Definire funzioni'], correctAnswer: 'Stampare su console'),
  Question(text: 'Quale linguaggio è tipicamente usato per IA?', options: ['Prolog', 'HTML', 'CSS', 'LaTeX'], correctAnswer: 'Prolog'),
  Question(text: 'La sintassi di un linguaggio riguarda:', options: ['La forma del codice', 'L’efficienza', 'La velocità', 'I risultati'], correctAnswer: 'La forma del codice'),
  Question(text: 'La semantica riguarda:', options: ['Il significato del codice', 'Il numero di righe', 'Il tempo di esecuzione', 'Il colore del testo'], correctAnswer: 'Il significato del codice'),
  Question(text: 'Il termine “parsing” indica:', options: ['Analisi sintattica del codice', 'Esecuzione', 'Compilazione', 'Stampa'], correctAnswer: 'Analisi sintattica del codice'),
  Question(text: 'Haskell è un linguaggio:', options: ['Funzionale', 'Imperativo', 'Procedurale', 'Visuale'], correctAnswer: 'Funzionale'),
  Question(text: 'Cosa sono i token?', options: ['Unità minime di significato nel codice', 'Variabili temporanee', 'Blocchi di memoria', 'Oggetti compilati'], correctAnswer: 'Unità minime di significato nel codice'),
],

};
