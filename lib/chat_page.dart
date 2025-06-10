import 'package:flutter/material.dart';
import 'chat_detail_page.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  final List<Map<String, String>> chats = const [
    {
      'name': 'Mario Bianchi',
      'preview': '“Ciao! Hai visto l’esercizio?”',
      'avatar': 'assets/avatar/complexion/white/Avatar_wh_bru_m.png',
    },
    {
      'name': 'Simona Ventura',
      'preview': '“Andiamo in aula studio alle 14?”',
      'avatar': 'assets/avatar/complexion/white/Avatar_wh_bio_f.png',
    },
    {
      'name': 'Luca Rossi',
      'preview': '“Domani c’è lezione di PPM, vieni?”',
      'avatar': 'assets/avatar/complexion/black/Avatar_bla_bru_m.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        centerTitle: true,
        title: const Text("Chat", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ListTile(
            leading: Image.asset(chat['avatar']!, width: 48, height: 48),

            title: Text(
              chat['name']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(chat['preview']!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatDetailPage(userName: chat['name']!),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF003366),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
