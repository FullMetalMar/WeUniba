import 'package:flutter/material.dart';

class SessionData {
  static String nome = "";
  static String avatarPath = "";
  static String badgePath = "";
  static String titolo = "";
  static String portafortunaPath = "";
  static bool isAvatarPopupShown = false;

  static int livello = 5;
  static int xpCorrente = 70;
  static int xpMassimo = 100;
  static final ValueNotifier<double> xpAnimatedNotifier = ValueNotifier<double>(
    xpCorrente.toDouble(),
  );

  static String? accessorioEquipaggiato; // può essere null

  static void aggiungiXP(BuildContext context, int xp) {
    int oldLevel = livello;
    xpCorrente += xp;

    while (xpCorrente >= xpMassimo) {
      xpCorrente -= xpMassimo;
      livello++;
      xpMassimo = _calcolaXPPerLivello(livello);
    }

    // Notifica l'XP animata per la barra animata
    xpAnimatedNotifier.value = xpCorrente.toDouble();

    if (livello > oldLevel) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "🎉 Level Up!",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text("Complimenti! Ora sei al livello $livello"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Ok"),
            ),
          ],
        ),
      );
    }
  }

  static int _calcolaXPPerLivello(int livello) {
    return 100 + (livello - 1) * 25;
  }

  // --- Inventario iniziale ---
  static final List<Map<String, String>> badgeInventario = [
    {
      "titolo": "Lag Spirituale",
      "path": "assets/badges/badge_lag_spirituale.png",
    },
    {
      "titolo": "Caffeina nel Sangue",
      "path": "assets/badges/badge_caffeina_nel_sangue.png",
    },
    {"titolo": "Sempre in Ritardo", "path": "assets/badges/badge_ritardo.png"},
  ];

  static final List<Map<String, String>> accessoriInventario = [
    {
      "nome": "Cappellino Brandizzato",
      "path": "assets/avatar/accessories/accessorio_cappellino.png",
    },
    {
      "nome": "Occhiali da vista",
      "path": "assets/avatar/accessories/accessorio_occhiali.png",
    },
    {
      "nome": "Felpa Brandizzata",
      "path": "assets/avatar/accessories/accessorio_felpa.png",
    },
  ];

  static final List<Map<String, String>> portafortunaInventario = [
    {
      'nome': 'Prof.ssa x al Mare',
      'path': 'assets/lucky_charms/santino_prof_mare.png',
    },
    {
      'nome': 'Prof. x in stile Cyberpunk',
      'path': 'assets/lucky_charms/santino_prof_cyberpunk.png',
    },
    {
      'nome': 'Prof. x Agraria',
      'path': 'assets/lucky_charms/santino_prof_agraria.png',
    },
  ];
}
