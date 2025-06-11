import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class ChatDetailPage extends StatefulWidget {
  final String userName;
  const ChatDetailPage({super.key, required this.userName});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isBotTyping = false;

  final List<String> _botReplies = [
    "Ciao! Come posso aiutarti?",
    "Hai già visto la nuova missione di oggi?",
    "Non dimenticare di riscattare i tuoi premi!",
    "Ottimo lavoro! Continua così!",
    "Vuoi un suggerimento su cosa fare dopo?",
    "Hai bisogno di aiuto con qualche esercizio?",
    "Ricorda di controllare il tuo portafortuna!",
    "Hai già completato le missioni di oggi?",
    "Sei pronto per la prossima sfida?",
    "Hai qualche domanda sulla lezione di oggi?",
    "Spero che tu stia trovando tutto interessante!",
    "Non dimenticare di fare una pausa ogni tanto!",
    "Hai già parlato con i tuoi compagni di corso?",
  ];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.insert(0, {'sender': 'Tu', 'text': text});
      _controller.clear();
      _isBotTyping = true;
    });

    Timer(const Duration(seconds: 2), () {
      final random = Random();
      final reply = _botReplies[random.nextInt(_botReplies.length)];
      setState(() {
        _isBotTyping = false;
        _messages.insert(0, {'sender': 'Bot', 'text': reply});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF003366),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length + (_isBotTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isBotTyping && index == 0) {
                  return const TypingIndicator();
                }
                final msgIndex = _isBotTyping ? index - 1 : index;
                final msg = _messages[msgIndex];
                return Align(
                  alignment: msg['sender'] == 'Tu'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg['sender'] == 'Tu'
                          ? const Color(0xFF003366)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg['text'] ?? '',
                      style: TextStyle(
                        color: msg['sender'] == 'Tu'
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Scrivi un messaggio",
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF003366)),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _dotOne;
  late Animation<double> _dotTwo;
  late Animation<double> _dotThree;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _dotOne = Tween<double>(begin: 0, end: -4).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
      ),
    );

    _dotTwo = Tween<double>(begin: 0, end: -4).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.5, curve: Curves.easeInOut),
      ),
    );

    _dotThree = Tween<double>(begin: 0, end: -4).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.7, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, animation.value),
          child: child,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDot(_dotOne),
          _buildDot(_dotTwo),
          _buildDot(_dotThree),
        ],
      ),
    );
  }
}
