import 'package:flutter/material.dart';
import 'chat_detail_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  List<Map<String, String>> chats = [
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

  List<Map<String, String>> friends = [
    {
      'name': 'Mario Bianchi',
      'avatar': 'assets/avatar/complexion/white/Avatar_wh_bru_m.png',
    },
    {
      'name': 'Simona Ventura',
      'avatar': 'assets/avatar/complexion/white/Avatar_wh_bio_f.png',
    },
    {
      'name': 'Luca Rossi',
      'avatar': 'assets/avatar/complexion/black/Avatar_bla_bru_m.png',
    },
    {
      'name': 'Chiara Neri',
      'avatar': 'assets/avatar/complexion/white/Avatar_wh_ros_f.png',
    },
    {
      'name': 'Giovanni Verdi',
      'avatar': 'assets/avatar/complexion/black/Avatar_bla_bio_m.png',
    },
    {
      'name': 'Martina Blu',
      'avatar': 'assets/avatar/complexion/white/Avatar_wh_bio_f.png',
    },
    {
      'name': 'Alessandro Gialli',
      'avatar': 'assets/avatar/complexion/black/Avatar_bla_ros_m.png',
    },
  ];

  void _addFriend(String username) {
    final exists = friends.any((f) => f['name'] == username);
    if (!exists) {
      setState(() {
        friends.add({
          'name': username,
          'avatar': 'assets/avatar/complexion/white/Avatar_wh_bio_m.png',
        });
      });
    }
  }

  void _startChat(Map<String, String> friend) async {
    final alreadyInChats = chats.any((c) => c['name'] == friend['name']);
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ChatDetailPage(userName: friend['name']!, initialMessage: ''),
      ),
    );

    if (result != null && result.trim().isNotEmpty) {
      setState(() {
        if (alreadyInChats) {
          // aggiorna anteprima
          final chat = chats.firstWhere((c) => c['name'] == friend['name']);
          chat['preview'] = result;
        } else {
          chats.add({
            'name': friend['name']!,
            'preview': result,
            'avatar': friend['avatar']!,
          });
        }
      });
    }
  }

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
              Tab(
                child: Text('Chat', style: TextStyle(color: Colors.white)),
              ),
              Tab(
                child: Text('Amici', style: TextStyle(color: Colors.white)),
              ),
            ],
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            // Chat Tab
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
                  subtitle: Text(chat['preview'] ?? ''),
                  onTap: () async {
                    final result = await Navigator.push<String>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatDetailPage(
                          userName: chat['name']!,
                          initialMessage: chat['preview'] ?? '',
                        ),
                      ),
                    );
                    if (result != null && result.trim().isNotEmpty) {
                      setState(() {
                        chat['preview'] = result;
                      });
                    }
                  },
                );
              },
            ),

            // Friends Tab
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
                                      _startChat(friend);
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
                      showDialog(
                        context: context,
                        builder: (_) {
                          final controller = TextEditingController();
                          return AlertDialog(
                            title: const Text("Aggiungi amico"),
                            content: TextField(
                              controller: controller,
                              decoration: const InputDecoration(
                                hintText: "Nome utente",
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Annulla"),
                              ),
                              TextButton(
                                onPressed: () {
                                  final username = controller.text.trim();
                                  if (username.isNotEmpty) {
                                    _addFriend(username);
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Richiesta inviata a $username",
                                        ),
                                        backgroundColor: const Color(
                                          0xFF003366,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Text("Aggiungi"),
                              ),
                            ],
                          );
                        },
                      );
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
