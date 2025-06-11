import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class ChatDetailPage extends StatefulWidget {
  final String userName;
  final String? initialMessage;
  final String? avatarPath;

  const ChatDetailPage({
    super.key,
    required this.userName,
    this.initialMessage,
    this.avatarPath,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage>
    with SingleTickerProviderStateMixin {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isBotTyping = false;
  bool _hasText = false;

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

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage != null) {
      _messages.insert(0, {
        'sender': widget.userName,
        'text': widget.initialMessage!,
      });
    }
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.trim().isNotEmpty;
      });
    });
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.insert(0, {'sender': 'Tu', 'text': text});
      _controller.clear();
      _isBotTyping = true;
    });

    Timer(const Duration(seconds: 2), () {
      final reply = _botReplies[Random().nextInt(_botReplies.length)];
      setState(() {
        _isBotTyping = false;
        _messages.insert(0, {'sender': 'Bot', 'text': reply});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF003366)),
          onPressed: () {
            // Cerca l'ultimo messaggio inviato dall'utente
            final lastUserMessage = _messages.firstWhere(
              (m) => m['sender'] == 'Tu',
              orElse: () => {'text': ''},
            )['text'];
            Navigator.pop(context, lastUserMessage);
          },
        ),

        title: Row(
          children: [
            if (widget.avatarPath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  widget.avatarPath!,
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.userName,
                style: const TextStyle(
                  color: Color(0xFF003366),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.videocam, color: Color(0xFF003366)),
          SizedBox(width: 16),
          Icon(Icons.call, color: Color(0xFF003366)),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length + (_isBotTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isBotTyping && index == 0) {
                  return const TypingIndicator();
                }
                final msgIndex = _isBotTyping ? index - 1 : index;
                final msg = _messages[msgIndex];
                final isUser = msg['sender'] == 'Tu';

                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isUser ? const Color(0xFF003366) : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isUser ? 16 : 0),
                        bottomRight: Radius.circular(isUser ? 0 : 16),
                      ),
                    ),
                    child: Text(
                      msg['text'] ?? '',
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 8,
              bottom: 20,
              top: 4,
            ),

            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.add, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: const InputDecoration(
                                hintText: "Scrivi un messaggio",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const Icon(Icons.emoji_emotions, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                    child: _hasText
                        ? IconButton(
                            key: const ValueKey('send'),
                            icon: const Icon(
                              Icons.send,
                              color: Color(0xFF003366),
                            ),
                            onPressed: _sendMessage,
                          )
                        : Row(
                            key: const ValueKey('icons'),
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Color(0xFF003366),
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.mic,
                                  color: Color(0xFF003366),
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                  ),
                ],
              ),
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 12),
          _buildDot(_dotOne),
          _buildDot(_dotTwo),
          _buildDot(_dotThree),
        ],
      ),
    );
  }
}
