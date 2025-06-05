import 'package:flutter/material.dart';
import 'package:weuniba_flutter/map_page.dart';
import 'package:weuniba_flutter/obiettivi_page.dart';
import 'inventory_page.dart';
import 'missions_page.dart';
import 'learning_material_page.dart';
import 'shop_page.dart';
import 'tutor_page.dart';

class HomePageWeUniba extends StatefulWidget {
  const HomePageWeUniba({super.key});

  @override
  State<HomePageWeUniba> createState() => _HomePageWeUnibaState();
}

class _HomePageWeUnibaState extends State<HomePageWeUniba> {
  int _currentIndex = 0;

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
            height: 72,
            color: const Color(0xFF003366),
            padding: const EdgeInsets.only(
              top: 24,
              left: 16,
              right: 16,
              bottom: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.settings, color: Colors.white),
                    SizedBox(width: 12),
                    Icon(Icons.help_outline, color: Colors.white),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Livello 5',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 100,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.7,
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
                          );
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
                              builder: (_) => const ObiettiviPage(),
                            ),
                          );
                        } else if (item['label'] == 'Eventi') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Funzionalità in arrivo!'),
                            ),
                          );
                        } else if (item['label'] == 'Gioco') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Funzionalità in arrivo!'),
                            ),
                          );
                        }

                        // Aggiungi altre condizioni se vuoi gestire altri pulsanti
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF003366),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profilo'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        ],
      ),
    );
  }
}
