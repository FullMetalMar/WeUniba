class SessionData {
  static String nome = "";
  static String avatarPath = "";
  static String badgePath = "";
  static String titolo = "";
  static String portafortunaPath = "";
  static bool isAvatarPopupShown = false;

  // Inventario statico iniziale
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
      "nome": "Cappellino",
      "path": "assets/avatar/accessories/accessorio_cappellino.png",
    },
    {
      "nome": "Occhiali",
      "path": "assets/avatar/accessories/accessorio_occhiali.png",
    },
    {"nome": "Felpa", "path": "assets/avatar/accessories/accessorio_felpa.png"},
  ];

  static final List<Map<String, String>> portafortunaInventario = [
    {
      "nome": "Santino Uomo",
      "path": "assets/lucky_charms/santino_fake_man.png",
    },
    {
      "nome": "Santino Donna",
      "path": "assets/lucky_charms/santino_fake_woman.png",
    },
  ];
}
