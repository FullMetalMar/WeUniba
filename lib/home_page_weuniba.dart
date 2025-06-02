import 'package:flutter/material.dart';

class HomePageWeUniba extends StatefulWidget {
  const HomePageWeUniba({super.key});

  @override
  State<HomePageWeUniba> createState() => _HomePageWeUnibaState();
}

class _HomePageWeUnibaState extends State<HomePageWeUniba> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _gridItems = [
    {'icon': 'assets/buttons/shop_icon.png', 'label': 'Negozio'},
    {'icon': 'assets/buttons/mission_icon.png', 'label': 'Missioni'},
    {'icon': 'assets/buttons/inventory_icon.png', 'label': 'Inventario'},
    {'icon': 'assets/buttons/map_icon.png', 'label': 'Mappa'},
    {'icon': 'assets/buttons/tutor_icon.png', 'label': 'Tutor'},
    {'icon': 'assets/buttons/material_icon.jpg', 'label': 'Materiale Didattico'},
    {'icon': 'assets/buttons/game_icon.png', 'label': 'Giochi'},
    {'icon': 'assets/buttons/event_icon.png', 'label': 'Eventi'},
    {'icon': 'assets/buttons/achievement_icon.jpg', 'label': 'Obiettivi'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SafeArea(
            child: SizedBox(
              height: 24,
              child: ColoredBox(color: Color(0xFF003366)),
            ),
          ),

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
                        )
                      ],
                    ),
                    child: InkWell(
                      onTap: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            item['icon'],
                            width: 36,
                            height: 36,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['label'],
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

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.circle, size: 10, color: Color(0xFF003366)),
              SizedBox(width: 8),
              Icon(Icons.circle_outlined, size: 10, color: Colors.grey),
            ],
          ),

          const SizedBox(height: 8),
        ],
      ),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profilo',
          ),
        ],
      ),
    );
  }
}
