// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:math';
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
import 'game_page.dart';

class HomePageWeUniba extends StatefulWidget {
  final String username;

  const HomePageWeUniba({super.key, required this.username});

  @override
  State<HomePageWeUniba> createState() => _HomePageWeUnibaState();
}

class _HomePageWeUnibaState extends State<HomePageWeUniba>
    with SingleTickerProviderStateMixin {
  final List<Map<String, String>> _gridItems = [
    {'icon': 'assets/buttons/inventory_icon.png', 'label': 'Inventario'},
    {'icon': 'assets/buttons/map_icon.png', 'label': 'Mappa'},
    {'icon': 'assets/buttons/mission_icon.png', 'label': 'Missioni'},
    {'icon': 'assets/buttons/material_icon.png', 'label': 'Materiale'},
    {'icon': 'assets/buttons/shop_icon.png', 'label': 'Negozio'},
    {'icon': 'assets/buttons/tutor_icon.png', 'label': 'Tutor'},
    {'icon': 'assets/buttons/achievement_icon.png', 'label': 'Obiettivi'},
    {'icon': 'assets/buttons/event_icon.png', 'label': 'Eventi'},
    {'icon': 'assets/buttons/game_icon.png', 'label': 'Gioco'},
  ];

  final bool _showDailyPopup = true;
  bool _isAnimatingXP = false;

  late AnimationController _xpController;
  late Animation<double> _xpAnimation;
  double _animatedXP = SessionData.xpCorrente.toDouble();

  @override
  void initState() {
    super.initState();

    _xpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _xpAnimation =
        Tween<double>(begin: _animatedXP, end: _animatedXP).animate(
          CurvedAnimation(parent: _xpController, curve: Curves.easeInOut),
        )..addListener(() {
          setState(() {
            _animatedXP = _xpAnimation.value;
          });
        });

    if (_showDailyPopup) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _showDailyRewardPopup(),
      );
    }
  }

  @override
  void dispose() {
    _xpController.dispose();
    super.dispose();
  }

  void _showDailyRewardPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Daily Reward',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(7, (index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      _triggerXPRewardAnimation();
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '50 XP',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                } else {
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.lock_outline, color: Colors.grey),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _triggerXPRewardAnimation() async {
    if (_isAnimatingXP) return;
    setState(() => _isAnimatingXP = true);

    int rewardXP = 50;
    int xpToAdd = rewardXP;

    int oldLevel = SessionData.livello;

    // Calcolo XP totale per gestire overflow barra e passaggio livelli
    int startTotalXP =
        SessionData.livello * SessionData.xpMassimo + SessionData.xpCorrente;
    int targetTotalXP = startTotalXP + xpToAdd;

    while (startTotalXP < targetTotalXP) {
      int currentLevel = startTotalXP ~/ SessionData.xpMassimo;
      int currentXPInLevel = startTotalXP % SessionData.xpMassimo;

      int nextLevelXP = (currentLevel + 1) * SessionData.xpMassimo;
      int nextXPTarget = min(nextLevelXP, targetTotalXP);

      int xpThisStep = nextXPTarget - startTotalXP;

      _xpAnimation =
          Tween<double>(
              begin: _animatedXP,
              end: currentXPInLevel + xpThisStep.toDouble(),
            ).animate(
              CurvedAnimation(parent: _xpController, curve: Curves.easeInOut),
            )
            ..addListener(() {
              setState(() {
                _animatedXP = _xpAnimation.value;
              });
            });

      _xpController.reset();
      await _xpController.forward();

      startTotalXP += xpThisStep;

      // Aggiorna dati reali
      SessionData.xpCorrente = (startTotalXP % SessionData.xpMassimo).toInt();
      SessionData.livello = currentLevel;

      // Popup se si è saliti di livello
      if (SessionData.livello > oldLevel) {
        oldLevel = SessionData.livello;
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              '🎉 Level Up!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Complimenti! Ora sei al livello ${SessionData.livello}',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ok'),
              ),
            ],
          ),
        );
      }
    }

    setState(() {
      _isAnimatingXP = false;
    });
  }

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
                            widthFactor: _animatedXP / SessionData.xpMassimo,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
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
                        switch (item['label']) {
                          case 'Inventario':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const InventoryPage(),
                              ),
                            );
                            break;
                          case 'Mappa':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MapPage(),
                              ),
                            );
                            break;
                          case 'Missioni':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MissionsPage(),
                              ),
                            ).then((_) => setState(() {}));
                            break;
                          case 'Materiale':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LearningMaterialPage(),
                              ),
                            );
                            break;
                          case 'Negozio':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ShopPage(),
                              ),
                            );
                            break;
                          case 'Tutor':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TutorPage(),
                              ),
                            );
                            break;
                          case 'Obiettivi':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AchievementPage(),
                              ),
                            );
                            break;
                          case 'Eventi':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const EventPage(),
                              ),
                            );
                            break;
                          case 'Gioco':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const GamePage(),
                              ),
                            );
                            break;
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(item['icon']!, width: 36, height: 36),
                          const SizedBox(height: 8),
                          Text(
                            item['label']!,
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AccountPage(username: widget.username),
                    ),
                  ),
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
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatPage()),
                  ),
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
