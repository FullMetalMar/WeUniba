import 'package:flutter/material.dart';
import 'weuniba_transistion_screen.dart';

class HomePageMyUniba extends StatefulWidget {
  final String username;

  const HomePageMyUniba({super.key, required this.username});

  @override
  State<HomePageMyUniba> createState() => _HomePageMyUnibaState();
}

class _HomePageMyUnibaState extends State<HomePageMyUniba> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _gridItems = [
    {'icon': Icons.check_box, 'label': 'Rilevazione Frequenze'},
    {'icon': Icons.calendar_today, 'label': 'Calendario esami'},
    {'icon': Icons.assignment_turned_in, 'label': 'Bacheca esiti'},
    {'icon': Icons.schedule, 'label': 'Agenda'},
    {'icon': Icons.dashboard, 'label': 'Cruscotto'},
    {'icon': Icons.fact_check, 'label': 'Questionari'},
    {'icon': Icons.mail_outline, 'label': 'Messaggi'},
    {'icon': Icons.newspaper, 'label': 'Feed'},
    {'icon': Icons.account_balance, 'label': 'Ateneo'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top bar blu (simula status bar)
          const SafeArea(
            top: true,
            bottom: false,
            left: false,
            right: false,
            child: SizedBox(
              height: 24,
              child: ColoredBox(color: Color(0xFF003366)),
            ),
          ),

          // Spazio aggiuntivo prima del pulsante
          const SizedBox(height: 8),

          // Pulsante quadrato con solo il logo ingrandito
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: 100,
                height: 100,
                child: Hero(
                  tag: 'weuniba-logo',
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WeUnibaTransitionScreen(
                            username: widget.username,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5F5F5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      padding: EdgeInsets.zero,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/logo/weuniba_logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Griglia centrata
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
                        // Azione al tocco
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item['icon'],
                            size: 36,
                            color: const Color(0xFF003366),
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

          // Indicatori di pagina
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

      // Bottom Navigation Bar
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Piano Studio',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.euro), label: 'Pagamenti'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Libretto'),
        ],
      ),
    );
  }
}
