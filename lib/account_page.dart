import 'package:flutter/material.dart';
import 'avatar_page.dart';
import 'session_data.dart';

class AccountPage extends StatefulWidget {
  final String username;

  const AccountPage({super.key, required this.username});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String avatarScelto = "";
  bool avatarSelezionato = false;
  String? genere;
  String? carnagione;

  String? badgeSelezionato;
  String? badgePathSelezionato;

  String? portafortunaSelezionato;
  String? portafortunaPathSelezionato;

  @override
  void initState() {
    super.initState();

    if (!SessionData.isAvatarPopupShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mostraPopupSceltaAvatar();
        SessionData.isAvatarPopupShown = true;
      });
    }
  }

  void _mostraPopupSceltaAvatar() {
    String? sessoTemp = genere;
    String? carnagioneTemp = carnagione;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            bool stepGenereConfermato = genere != null;
            bool stepCarnagioneConfermato = carnagione != null;

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 120,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!stepGenereConfermato) ...[
                      const Text(
                        "Chi vuoi essere?",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _genderButton(
                            setStateDialog,
                            sessoTemp,
                            "m",
                            "Ragazzo",
                            (val) => sessoTemp = val,
                          ),
                          _genderButton(
                            setStateDialog,
                            sessoTemp,
                            "f",
                            "Ragazza",
                            (val) => sessoTemp = val,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            if (sessoTemp != null) {
                              setStateDialog(() {
                                genere = sessoTemp;
                              });
                            }
                          },
                          child: const Text("Conferma"),
                        ),
                      ),
                    ] else if (!stepCarnagioneConfermato) ...[
                      const Text(
                        "Scegli la tua carnagione",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _skinButton(
                            setStateDialog,
                            carnagioneTemp,
                            "scura",
                            const Color(0xFF66320A),
                            (val) => carnagioneTemp = val,
                          ),
                          const SizedBox(width: 20),
                          _skinButton(
                            setStateDialog,
                            carnagioneTemp,
                            "chiara",
                            const Color(0xFFEAC58E),
                            (val) => carnagioneTemp = val,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            if (carnagioneTemp != null) {
                              setStateDialog(() {
                                carnagione = carnagioneTemp;
                              });
                            }
                          },
                          child: const Text("Conferma"),
                        ),
                      ),
                    ] else ...[
                      const Text(
                        "Avatar selezionato!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          String avatarPath = "";
                          if (genere == "m" && carnagione == "scura") {
                            avatarPath =
                                "assets/avatar/complexion/black/Avatar_bla_bru_m.png";
                          } else if (genere == "f" && carnagione == "scura") {
                            avatarPath =
                                "assets/avatar/complexion/black/Avatar_bla_bru_f.png";
                          } else if (genere == "m" && carnagione == "chiara") {
                            avatarPath =
                                "assets/avatar/complexion/white/Avatar_wh_bru_m.png";
                          } else if (genere == "f" && carnagione == "chiara") {
                            avatarPath =
                                "assets/avatar/complexion/white/Avatar_wh_bru_f.png";
                          }

                          setState(() {
                            avatarScelto = avatarPath;
                            avatarSelezionato = true;
                            SessionData.avatarPath = avatarPath;
                          });

                          Navigator.pop(context);
                        },
                        child: const Text("Conferma Avatar"),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _genderButton(
    void Function(void Function()) setStateDialog,
    String? sessoSelezionato,
    String value,
    String label,
    void Function(String) aggiornaTemp,
  ) {
    final isSelected = sessoSelezionato == value;

    return GestureDetector(
      onTap: () => setStateDialog(() => aggiornaTemp(value)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.transparent,
                width: 3,
              ),
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: isSelected ? Colors.blue[100] : Colors.grey[200],
              child: Icon(
                value == "m" ? Icons.male : Icons.female,
                color: Colors.black87,
                size: 30,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.blue : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _skinButton(
    void Function(void Function()) setStateDialog,
    String? carnagioneSelezionata,
    String value,
    Color color,
    void Function(String) aggiornaTemp,
  ) {
    final isSelected = carnagioneSelezionata == value;

    return GestureDetector(
      onTap: () => setStateDialog(() => aggiornaTemp(value)),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 4 : 1,
          ),
        ),
      ),
    );
  }

  void _modificaNome() async {
    final controller = TextEditingController(text: SessionData.nome);
    final nuovoNome = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Modifica Nome"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Inserisci nuovo nome"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annulla"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text("Salva"),
          ),
        ],
      ),
    );

    if (nuovoNome != null && nuovoNome.isNotEmpty) {
      setState(() {
        SessionData.nome = nuovoNome;
      });
    }
  }

  void _modificaBadge() {
    // inizializza selezione con quella corrente
    badgeSelezionato = SessionData.titolo.isNotEmpty
        ? SessionData.titolo
        : null;
    badgePathSelezionato = SessionData.badgePath.isNotEmpty
        ? SessionData.badgePath
        : null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                "Scegli un badge",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: SessionData.badgeInventario.map((badge) {
                    final bool isSelected = badgeSelezionato == badge["titolo"];
                    return GestureDetector(
                      onTap: () {
                        setStateDialog(() {
                          badgeSelezionato = badge["titolo"];
                          badgePathSelezionato = badge["path"];
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? Colors.blue
                                : Colors.transparent,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(badge["path"]!, height: 64),
                            const SizedBox(height: 4),
                            Text(badge["titolo"]!),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      badgeSelezionato = null;
                      badgePathSelezionato = null;
                      SessionData.badgePath = "";
                      SessionData.titolo = "";
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Rimuovi badge"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (badgeSelezionato != null &&
                        badgePathSelezionato != null) {
                      setState(() {
                        SessionData.titolo = badgeSelezionato!;
                        SessionData.badgePath = badgePathSelezionato!;
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Conferma"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _cambiaPortafortuna() {
    // inizializza selezione con quella corrente
    portafortunaSelezionato = SessionData.portafortunaPath.isNotEmpty
        ? SessionData.portafortunaPath
        : null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                "Scegli un portafortuna",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: SessionData.portafortunaInventario.map((charm) {
                    return _buildPortafortunaItemSelectable(
                      charm['path']!,
                      charm['nome']!,
                      setStateDialog,
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      portafortunaSelezionato = null;
                      SessionData.portafortunaPath = "";
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Rimuovi portafortuna"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (portafortunaSelezionato != null) {
                      setState(() {
                        SessionData.portafortunaPath = portafortunaSelezionato!;
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Conferma"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPortafortunaItemSelectable(
    String path,
    String title,
    void Function(void Function()) setStateDialog,
  ) {
    final bool isSelected = portafortunaSelezionato == path;
    return GestureDetector(
      onTap: () {
        setStateDialog(() {
          portafortunaSelezionato = path;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(path, height: 64),
            const SizedBox(height: 4),
            Text(title),
          ],
        ),
      ),
    );
  }

  void _vaiAAvatarPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AvatarPage()),
    ).then((_) => setState(() {}));
  }

  Widget _buildBadgeCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Image.asset(SessionData.badgePath, height: 100),
    );
  }

  Widget _buildPortafortunaCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Image.asset(SessionData.portafortunaPath, height: 100),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Utente", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              SessionData.nome.isNotEmpty
                  ? SessionData.nome
                  : "Nome non impostato",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(widget.username, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            if (SessionData.avatarPath.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                height: 160,
                child: Image.asset(SessionData.avatarPath, fit: BoxFit.contain),
              ),
            if (SessionData.badgePath.isNotEmpty &&
                SessionData.portafortunaPath.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: _buildBadgeCard()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildPortafortunaCard()),
                ],
              )
            else if (SessionData.badgePath.isNotEmpty)
              _buildBadgeCard()
            else if (SessionData.portafortunaPath.isNotEmpty)
              _buildPortafortunaCard()
            else
              const Text("Nessun badge o portafortuna impostato"),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _modificaNome,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text("Modifica nome"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _vaiAAvatarPage,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text("Modifica avatar"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _modificaBadge,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text("Modifica badge"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _cambiaPortafortuna,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text("Modifica portafortuna"),
            ),
          ],
        ),
      ),
    );
  }
}
