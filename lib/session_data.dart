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
      "nome": "Cappellino Brandizzato",
      "path": "assets/avatar/accessories/accessorio_cappellino.png",
    },
    {
      "nome": "Occhiali specchiati in arancione",
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
