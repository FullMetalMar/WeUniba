import 'package:flutter/material.dart';
import 'chat_detail_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  final List<Map<String, String>> chats = [
    {
      'name': 'Mario Bianchi',
      'preview': 'Ciao! Hai visto l’esercizio?',
      'avatar': 'assets/avatar/complexion/white/Avatar_wh_bru_m.png',
    },
    {
      'name': 'Simona Ventura',
      'preview': 'Andiamo in aula studio alle 14?',
      'avatar': 'assets/avatar/complexion/white/Avatar_wh_bio_f.png',
    },
    {
      'name': 'Luca Rossi',
      'preview': 'Domani c’è lezione di PPM, vieni?',
      'avatar': 'assets/avatar/complexion/black/Avatar_bla_bru_m.png',
    },
  ];

  final List<Map<String, String>> friends = [
    {
      'name': 'Chiara Neri',
      'avatar': 'assets/avatar/complexion/white/Avatar_wh_ros_f.png',
    },
    {
      'name': 'Giovanni Verdi',
      'avatar': 'assets/avatar/complexion/black/Avatar_bla_bio_m.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF003366),
          centerTitle: true,
          title: const Text("Chat", style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Chat'),
              Tab(text: 'Amici'),
            ],
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            // Tab Chat
            ListView.builder(
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
                        builder: (_) => ChatDetailPage(
                          userName: chat['name']!,
                          initialMessage: chat['preview']!,
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            // Tab Amici
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                      final friend = friends[index];
                      return ListTile(
                        leading: Image.asset(
                          friend['avatar']!,
                          width: 48,
                          height: 48,
                        ),
                        title: Text(friend['name']!),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            builder: (_) => Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(
                                      Icons.chat,
                                      color: Color(0xFF003366),
                                    ),
                                    title: const Text("Chat"),
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ChatDetailPage(
                                            userName: friend['name']!,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    title: const Text("Rimuovi amico"),
                                    onTap: () {
                                      setState(() {
                                        friends.removeAt(index);
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003366),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      // Da implementare: logica per aggiungere amico
                    },
                    icon: const Icon(Icons.person_add),
                    label: const Text("Aggiungi amico"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
