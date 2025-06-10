import 'package:flutter/material.dart';
import 'package:weuniba_flutter/map_page.dart';
import 'package:weuniba_flutter/achievement_page.dart';
import 'inventory_page.dart';
import 'missions_page.dart';
import 'learning_material_page.dart';
import 'shop_page.dart';
import 'tutor_page.dart';
import 'event_page.dart';
import 'account_page.dart';
import 'settings_page.dart';
import 'help_page.dart';
import 'chat_page.dart';
import 'session_data.dart';

class HomePageWeUniba extends StatefulWidget {
  final String username;

  const HomePageWeUniba({super.key, required this.username});

  @override
  State<HomePageWeUniba> createState() => _HomePageWeUnibaState();
}

class _HomePageWeUnibaState extends State<HomePageWeUniba> {
  final List<Map<String, String>> _gridItems = [
    {'icon': 'assets/buttons/inventory_icon.png', 'label': 'Inventario'},
    {'icon': 'assets/buttons/map_icon.png', 'label': 'Mappa'},
    {'icon': 'assets/buttons/mission_icon.png', 'label': 'Missioni'},
    {'icon': 'assets/buttons/material_icon.jpg', 'label': 'Materiale'},
    {'icon': 'assets/buttons/shop_icon.png', 'label': 'Negozio'},
    {'icon': 'assets/buttons/tutor_icon.png', 'label': 'Tutor'},
    {'icon': 'assets/buttons/achievement_icon.jpg', 'label': 'Obiettivi'},
    {'icon': 'assets/buttons/event_icon.png', 'label': 'Eventi'},
    {'icon': 'assets/buttons/game_icon.png', 'label': 'Gioco'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top bar blu
          Container(
            height: 90,
            color: const Color(0xFF003366),
            padding: const EdgeInsets.only(
              top: 28,
              left: 16,
              right: 16,
              bottom: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingsPage(),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.help_outline, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const HelpPage()),
                        );
                      },
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${SessionData.xpCorrente}/${SessionData.xpMassimo} XP',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          'Livello ${SessionData.livello}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 100,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: SessionData.xpMassimo == 0
                                ? 0
                                : SessionData.xpCorrente /
                                      SessionData.xpMassimo,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Pulsante "Torna in MyUniba"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003366),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Torna in MyUniba',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),

          // Griglia dei pulsanti
          Expanded(
            child: Center(
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                padding: const EdgeInsets.all(16),
                children: _gridItems.map((item) {
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        if (item['label'] == 'Inventario') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const InventoryPage(),
                            ),
                          );
                        } else if (item['label'] == 'Mappa') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const MapPage()),
                          );
                        } else if (item['label'] == 'Missioni') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MissionsPage(),
                            ),
                          ).then((_) {
                            // Aggiorna la home per riflettere i nuovi XP
                            setState(() {});
                          });
                        } else if (item['label'] == 'Materiale') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LearningMaterialPage(),
                            ),
                          );
                        } else if (item['label'] == 'Negozio') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ShopPage()),
                          );
                        } else if (item['label'] == 'Tutor') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TutorPage(),
                            ),
                          );
                        } else if (item['label'] == 'Obiettivi') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AchievementPage(),
                            ),
                          );
                        } else if (item['label'] == 'Eventi') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EventPage(),
                            ),
                          );
                        } else if (item['label'] == 'Gioco') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Funzionalità in arrivo!'),
                            ),
                          );
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            item['icon'] ?? '',
                            width: 36,
                            height: 36,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['label'] ?? '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),

      // Barra di navigazione in basso
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AccountPage(username: widget.username),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.person, color: Color(0xFF003366), size: 26),
                      SizedBox(height: 2),
                      Text(
                        'Profilo',
                        style: TextStyle(
                          color: Color(0xFF003366),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChatPage()),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.chat, color: Color(0xFF003366), size: 26),
                      SizedBox(height: 2),
                      Text(
                        'Chat',
                        style: TextStyle(
                          color: Color(0xFF003366),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
