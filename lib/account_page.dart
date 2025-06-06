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

  @override
  void initState() {
    super.initState();

    if (!SessionData.isAvatarPopupShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mostraPopupSceltaAvatar();
        SessionData.isAvatarPopupShown = true; // segna che è stato mostrato
      });
    }
  }

  void _mostraPopupSceltaAvatar() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              "Scegli il tuo avatar",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Tocca un avatar per selezionarlo"),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setStateDialog(() {
                          avatarScelto = "female";
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: avatarScelto == "female"
                                ? Colors.blue
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: const CircleAvatar(
                          backgroundImage: AssetImage(
                            "assets/avatar/avatar_mezzo_female.png",
                          ),
                          radius: 50,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setStateDialog(() {
                          avatarScelto = "male";
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: avatarScelto == "male"
                                ? Colors.blue
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: const CircleAvatar(
                          backgroundImage: AssetImage(
                            "assets/avatar/avatar_mezzo_male.png",
                          ),
                          radius: 50,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  avatarSelezionato = true;
                  Navigator.pop(context);
                },
                child: const Text("Non ora"),
              ),
              ElevatedButton(
                onPressed: avatarScelto.isNotEmpty
                    ? () {
                        setState(() {
                          SessionData.avatarPath = avatarScelto == "female"
                              ? "assets/avatar/avatar_female.png"
                              : "assets/avatar/avatar_male.png";
                          avatarSelezionato = true;
                        });
                        Navigator.pop(context);
                      }
                    : null,
                child: const Text("Conferma scelta"),
              ),
            ],
          ),
        );
      },
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
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: SessionData.badgeInventario.map((badge) {
          return ListTile(
            leading: Image.asset(badge["path"]!, height: 40, width: 40),
            title: Text(badge["titolo"]!),
            onTap: () => _selezionaBadge(badge["titolo"]!, badge["path"]!),
          );
        }).toList(),
      ),
    );
  }

  void _selezionaBadge(String nuovoTitolo, String nuovoBadgePath) {
    setState(() {
      SessionData.titolo = nuovoTitolo;
      SessionData.badgePath = nuovoBadgePath;
    });
    Navigator.pop(context);
  }

  void _cambiaPortafortuna() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => _selezionaPortafortuna(
              "assets/lucky_charms/santino_fake_man.png",
            ),
            child: Image.asset(
              "assets/lucky_charms/santino_fake_man.png",
              height: 100,
            ),
          ),
          GestureDetector(
            onTap: () => _selezionaPortafortuna(
              "assets/lucky_charms/santino_fake_woman.png",
            ),
            child: Image.asset(
              "assets/lucky_charms/santino_fake_woman.png",
              height: 100,
            ),
          ),
        ],
      ),
    );
  }

  void _selezionaPortafortuna(String path) {
    setState(() {
      SessionData.portafortunaPath = path;
    });
    Navigator.pop(context);
  }

  void _vaiAAvatarPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AvatarPage()),
    ).then((_) => setState(() {}));
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

            if (SessionData.badgePath.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(SessionData.badgePath, height: 40),
                  const SizedBox(width: 8),
                  Text(
                    SessionData.titolo,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              )
            else
              const Text("Badge non impostato"),

            const SizedBox(height: 16),

            if (SessionData.portafortunaPath.isNotEmpty)
              Image.asset(SessionData.portafortunaPath, height: 80)
            else
              const Text("Portafortuna non impostato"),

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
